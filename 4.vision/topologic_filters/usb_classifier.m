%% read the image
I = imread('coins-usb.jpg');
%I = imread('eight.tif');
imshow(I);
I = rgb2gray(I);
imshow(I);

%% improve and binarize (removing bw noise)
se = strel('disk',120);  % carefully designed

background = imopen(I,se);
imshow(background);
I2 = I - background;
imshow(I2);

I3 = imadjust(I2);
imshow(I3);
I4 = imgaussfilt(I3,8);  % carefully designed
imshow(I4);
I5 = imadjust(I4);
imshow(I5);

bw = imbinarize(I4);
if sum(bw,'all') > numel(bw)/2
    bw = ~bw;
end
bw = bwareaopen(bw,50);
imshow(bw);


%% morphological analysis and show circles
cc = bwconncomp(bw,4);
fprintf('%d objects found\n', cc.NumObjects)
props = regionprops('table',cc,'Area','Centroid','Circularity','Eccentricity','MajorAxisLength','MinorAxisLength');
props.Index = (1:size(props,1))';

% filter circles
coins = props.Circularity > 0.96;
props_coins = props(coins,:);

imshow(I);
hold on;
% show circles
centers = props_coins.Centroid;
diameters = mean([props_coins.MajorAxisLength props_coins.MinorAxisLength],2);
viscircles(centers,diameters/2);
scatter(centers(:,1),centers(:,2),20,'filled','r');
% show not circles
centers = props(~coins,:).Centroid;
scatter(centers(:,1),centers(:,2),20,'filled','b');


%% show all CCs
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label)


%% compare circles
% show smallest and biggest
[vmin, argmin] = min(props_coins.Area);
obj_idx = props_coins(argmin,:).Index;
centroid = props_coins(obj_idx,:).Centroid;
text(centroid(1), centroid(2),'Smallest coin','HorizontalAlignment','center');

[vmax, argmax] = max(props_coins.Area);
obj_idx = props_coins(argmax,:).Index;
centroid = props_coins(obj_idx,:).Centroid;
text(centroid(1), centroid(2),'Biggest coin','HorizontalAlignment','center');

%% add anything else
centers = props(~coins,:).Centroid;
for i=1:size(centers,1)
    text(centers(i,1), centers(i,2),'Not a coin','HorizontalAlignment','center');
end

%obj = false(size(bw));
%obj(cc.PixelIdxList{obj_idx}) = true;
%imshow(obj);
%contour(obj);


























