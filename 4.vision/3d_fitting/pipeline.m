addpath('scripts');

%% isolate object
% load images
color = imread('0000025.jpg');  % RGB
depth = imread('0000025.png');  % [mm]

% show data
figure, imshowpair(color,depth,'montage');

near = 690 < depth & depth < 770;
near = imopen(near,strel('disk',10));
figure, imshow(near);

%% my pipeline
% apply distance mask and improve
I = color .* uint8(repmat(near,[1 1 3]));
figure, imshow(I);
I = cat(3,imadjust(I(:,:,1)),imadjust(I(:,:,2)),imadjust(I(:,:,3)));
figure, imshow(I);

% plot color distribution
C = double(reshape(I, [numel(I(:,:,1)) 3]));
C = C(reshape(near, [size(C,1) 1]),:);
figure, scatter3(C(:,1),C(:,2),C(:,3),5,C/255);
clear I

% collapse in 2D  on the smallest eigenvectors
[U,E] = eig(cov(C));
[~,i] = sort(diag(E));
U = U(:,i);
U = U(:,1:2);
clear E i

Y = (C-mean(C,1))*U;
figure, scatter(Y(:,1),Y(:,2),5,C/255);
clear U

% perform k-means on the colors
n_objs = 3;
[idxs,~] = kmeans(Y,n_objs,'MaxIter',100,'Start','plus');
figure, scatter(Y(:,1),Y(:,2),5,idxs);
figure, scatter3(C(:,1),C(:,2),C(:,3),5,idxs);
clear C Y

% extract masks
masks = false([size(near), n_objs]);
valid_pix = 1:numel(near);
valid_pix = valid_pix(reshape(near,[1, numel(near)]))';
for i=1:n_objs
    tmp = false(size(near));
    tmp(valid_pix(idxs == i)) = true;
    masks(:,:,i) = tmp;
end
clear idxs valid_pix tmp near

% show masks
for i=1:n_objs
    figure, imshow(masks(:,:,i)), title(sprintf('Mask %d',i));
end
clear n_objs

% select best one
[~,i] = max(sum(masks,[1 2]));
mask = masks(:,:,i);
figure, imshow(mask), title('Best mask');
clear i

%% OPT: fully implemented pipeline with imsegkmeans
lab_he = rgb2lab(color);
ab = lab_he(:,:,2:3);  % use just the a* and b* layers (ignore L*)
ab = im2single(ab);  % imsegkmeans does not work with double

% repeat the clustering 3 times to avoid local minima
nColors = 3;
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
figure, imshow(pixel_labels,[]);
clear ab lab_he

% recreate near mask
near = 690 < depth & depth < 770;
near = imopen(near,strel('disk',10));
I = pixel_labels .* uint8(near);
figure, imshow(I,[]);
clear pixel_labels

% extract masks
masks = false([size(near), nColors]);
for i=1:nColors
    masks(:,:,i) = I == i;
end
clear near I

% show masks
for i=1:nColors
    figure, imshow(masks(:,:,i)), title(sprintf('Mask %d',i));
end
clear nColors

% select best one
[~,i] = max(sum(masks,[1 2]));
mask = masks(:,:,i);
figure, imshow(mask), title('Best mask');
clear i

%% mask refinement
% refine mask
mask = bwareaopen(mask,1000);
mask = imfill(mask,'holes');
cc = bwconncomp(mask,4);
props = regionprops('table',cc,'Area');
[~, i] = max(props.Area);
mask(:,:) = false;
mask(cc.PixelIdxList{i}) = true;
clear cc props masks i

% get boundary
boundary = bwboundaries(mask);
boundary = boundary{1};  % there is only one object
mask_boundary = false(size(mask));
for i=1:length(boundary)
    mask_boundary(boundary(i,1),boundary(i,2)) = true;
end
clear i boundary

% show mask and boundary
show_mask = uint8(cat(3,mask,mask,mask))*255;
tmp = show_mask(:,:,1);
tmp(mask_boundary) = 255;
show_mask(:,:,1) = tmp;
tmp = show_mask(:,:,1);
tmp(mask_boundary) = 0;
show_mask(:,:,2) = tmp;
tmp = show_mask(:,:,1);
tmp(mask_boundary) = 0;
show_mask(:,:,3) = tmp;

figure, imshow(show_mask);
clear show_mask tmp

% show masked imaged
figure, imshow(color .* uint8(repmat(mask,[1 1 3])));




%% setup camera
% PrimeSense Carmine cameras
I.fx = 525;
I.fy = 525;
I.u0 = 319.5;  % principal point
I.v0 = 239.5;

%% get 3D cloud and boundary
P = project_image_to_points(I,depth,mask);
Pcol = mask_color(color,mask);

scatter3(P(:,1),P(:,2),P(:,3), 6, Pcol, '.');

PB = project_image_to_points(I,depth,mask_boundary);
PBcol = mask_color(color,mask_boundary);

hold on;
scatter3(PB(:,1),PB(:,2),PB(:,3), 6, 'r', '.');
hold off;




%% eventually, save cloud, boundaries and masks
ptCloud = pointCloud(P,'Color',Pcol);
pcwrite(ptCloud,'cloud.ply');
clear ptCloud

ptCloud = pointCloud(PB,'Color',PBcol);
pcwrite(ptCloud,'boundaries.ply');
clear ptCloud

save('masks.mat','mask','mask_boundary','I','color','depth');

%% eventually, load cloud, boundaries and masks
ptCloud = pcread('cloud.ply');
P = double(ptCloud.Location);
Pcol = double(ptCloud.Color)/255;
clear ptCloud

ptCloud = pcread('boundaries.ply');
PB = double(ptCloud.Location);
PBcol = double(ptCloud.Color)/255;
clear ptCloud

load('masks.mat');




%% centroid and orientation
cc = bwconncomp(mask,4);
props = regionprops('table',cc,'Centroid','Orientation');
c = props.Centroid;
d = props.Orientation;
clear props cc

% plot equidistanced points along the orientation line
m = -tand(d);  % we have a - here because images have y-axis flipped
D = [-10:2:-1 2:2:10];
x = c(1) + D/sqrt(1+m);  % by doing this, we have dist(c,p)=D
y = m*(x - c(1)) + c(2);
p = [x; y]';
clear x y D

imshow(mask);
hold on;
scatter(c(1),c(2),'r','filled');
scatter(p(:,1),p(:,2),'b','filled');
hold off;

% project line
M = uint16([c; p]);
p_mask = false(size(mask));
p_mask(sub2ind(size(mask),M(:,2),M(:,1))) = true;
PL = project_image_to_points(I,depth,p_mask);
[c,d] = fit_line_pca(PL);
clear M m p p_mask

% plot
scatter3(P(:,1),P(:,2),P(:,3), 6, Pcol, '.');
hold on;
scatter3(PL(:,1),PL(:,2),PL(:,3),'b','filled');
hold off;

L = -500:500;
plot_line(c,d,L);
clear c L m PL



%% plane fitting

scatter3(P(:,1),P(:,2),P(:,3),'.');

[c,n] = fit_plane(P);

% plot estimated plane
xv = -150:200;
yv = -150:200;
plot_plane(c,n,xv,yv);
clear xv yv

%% 3D object orientation
b = cross(n,d);
O = [n/norm(n),d/norm(d),b/norm(b)];  % just to be sure
clear b

% plot frame
S = 100;
O = O*S;
hold on;
quiver3(c(1),c(2),c(3),O(1,1),O(2,1),O(3,1),'LineWidth',5,'Color','red');
quiver3(c(1),c(2),c(3),O(1,2),O(2,2),O(3,2),'LineWidth',5,'Color','green');
quiver3(c(1),c(2),c(3),O(1,3),O(2,3),O(3,3),'LineWidth',5,'Color','blue');
hold off;

clear O S



%% fit contour lines (robust fitting on cloud features)
k = 100;
dist = 8;
n_samples = 50;

% divide rectangle in features (4 corners and 4 sides)
[idxs,C] = kmeans(PB,8);
scatter3(PB(:,1),PB(:,2),PB(:,3), 6, idxs, '.');

results_scores = zeros(1,8);
results = cell(1,8);
for i=1:8
    PB_feat = PB(idxs == i,:);
    [best_C, best_D, best_inlier, best_score] = ...
        ransac(PB_feat,k,dist,n_samples, ...
               @fit_line_pca, @distance_point_to_line);
    results_scores(i) = best_score;
    results{i} = {best_C, best_D, PB_feat(best_inlier,:)};
end
[~,idxs] = sort(results_scores,'descend');
perimeter_lines = results(idxs(1:4));
clear best_C best_D best_inlier best_score results results_scores idxs i k dist n_samples

% plot points and lines
scatter3(PB(:,1),PB(:,2),PB(:,3), 6, 'r', '.');
for i=1:4
    results = perimeter_lines{i};
    PB_feat = results{3};
    L = -200:200;
    C = results{1};
    D = results{2};
    plot_line(C,D,L);
end
clear i L C D results

%% ALT: fit contour lines (few samples)
k = 500;
dist = 4;
n_samples = 5;

inlier = false([size(PB,1) 1]);
perimeter_lines = cell(1,4);
for i=1:4
    [best_C, best_D, best_inlier, best_score] = ...
        ransac(PB(~inlier,:),k,dist,n_samples, ...
               @fit_line_pca, @distance_point_to_line);
    perimeter_lines{i} = {best_C, best_D};
    inlier(~inlier) = best_inlier;
end
clear best_C best_D best_inlier inlier results i k dist n_samples

% plot points and lines
scatter3(PB(:,1),PB(:,2),PB(:,3), 6, 'r', '.');
for i=1:4
    results = perimeter_lines{i};
    L = -200:200;
    C = results{1};
    D = results{2};
    plot_line(C,D,L);
end
clear i L C D results



%% corners

% compute angles w.r.t. the first line
d1 = perimeter_lines{1}{2};
other_lines_angles = [0 0 0];
other_lines_idxs = [2 3 4];
for i=other_lines_idxs
    d2 = perimeter_lines{i}{2};
    other_lines_angles(i-1) = angle_between_lines(d1,d2);
end
% separate lines near to the first one and the other parallel line
near_lines_idxs_mask = 85 < other_lines_angles & other_lines_angles < 95;
near_lines_idxs = other_lines_idxs(near_lines_idxs_mask);
far_line_idx = other_lines_idxs(~near_lines_idxs_mask);
clear other_lines_angles other_lines_idxs near_lines_idxs_mask

corners = zeros([4 3]);
% compute intersection between first line and the near lines
c1 = perimeter_lines{1}{1};
d1 = perimeter_lines{1}{2};
for i=1:length(near_lines_idxs)
    c2 = perimeter_lines{near_lines_idxs(i)}{1};
    d2 = perimeter_lines{near_lines_idxs(i)}{2};
    [~,~,m] = intersection_between_lines(c1,d1,c2,d2);
    corners(i,:) = m;
end
% compute intersection between the parallel line and the near lines
c1 = perimeter_lines{far_line_idx}{1};
d1 = perimeter_lines{far_line_idx}{2};
for i=1:length(near_lines_idxs)
    c2 = perimeter_lines{near_lines_idxs(i)}{1};
    d2 = perimeter_lines{near_lines_idxs(i)}{2};
    [~,~,m] = intersection_between_lines(c1,d1,c2,d2);
    corners(i+2,:) = m;
end
clear i c1 d1 j c2 d2 results far_line_idx near_lines_idxs

% plot intersections
hold on;
scatter3(corners(:,1),corners(:,2),corners(:,3), 500, 'k', '.');
hold off;
