%% read the image
I = imread('pens-hanky.jpg');
imshow(I);
I = rgb2gray(I);
imshow(I);

%% improve
I2 = imopen(I,strel('disk',30));
imshow(I2);

I3 = imadjust(I2);
imshow(I3);

%% binarize
bw = imbinarize(I3);
if sum(bw,'all') > numel(bw)/2
    bw = ~bw;
end
bw = bwareaopen(bw,1000);

bw = imfill(bw,'holes');
imshow(bw);


%% morphological analysis and show circles
cc = bwconncomp(bw,4);
fprintf('%d objects found\n', cc.NumObjects)
props = regionprops('table',cc,'Area','Centroid','Circularity','Eccentricity','BoundingBox');
props.Index = (1:size(props,1))';

% filter pens
pens = props.Circularity < 0.3 & props.Eccentricity > 0.9;
props_pens = props(pens,:);

imshow(I);
hold on;
% show pens
centers = props_pens.Centroid;
for i=1:size(centers,1)
    rectangle('Position',props_pens.BoundingBox(i,:),'EdgeColor','red');
end
scatter(centers(:,1),centers(:,2),20,'filled','r');
% show not pens
centers = props(~pens,:).Centroid;
for i=1:size(centers,1)
    rectangle('Position',props(~pens,:).BoundingBox(i,:),'EdgeColor','green');
end
scatter(centers(:,1),centers(:,2),20,'filled','g');


%% show all CCs
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label)


%% compare circles
% show smallest and biggest
[vmin, argmin] = min(props_pens.Area);
obj_idx = props_pens(argmin,:).Index;
centroid = props_pens(obj_idx,:).Centroid;
text(centroid(1), centroid(2),'Smallest pen','HorizontalAlignment','center');

[vmax, argmax] = max(props_pens.Area);
obj_idx = props_pens(argmax,:).Index;
centroid = props_pens(obj_idx,:).Centroid;
text(centroid(1), centroid(2),'Biggest pen','HorizontalAlignment','center');

%% add anything else
centers = props(~pens,:).Centroid;
for i=1:size(centers,1)
    text(centers(i,1), centers(i,2),'Not a pen','HorizontalAlignment','center','Color','red');
end

%obj = false(size(bw));
%obj(cc.PixelIdxList{obj_idx}) = true;
%imshow(obj);
%contour(obj);


























