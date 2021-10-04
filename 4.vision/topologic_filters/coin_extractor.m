%% read the image
I = imread('eight.tif');
imshow(I);

%% improve and binarize (removing bw noise)
se = strel('disk',150);  % carefully designed

background = imopen(I,se);
imshow(background);
I2 = I - background;
imshow(I2);

I3 = imadjust(I2);
imshow(I3);
I4 = imgaussfilt(I3,1);  % carefully designed
imshow(I4);
I5 = imadjust(I4);
imshow(I5);

bw = imbinarize(I4);
bw = bwareaopen(bw,50);
bw = ~bw;
imshow(bw);


%% morphological analysis and show the biggest CC
cc = bwconncomp(bw,4);
fprintf('%d objects found\n', cc.NumObjects)
props = regionprops('table',cc,'Area','Centroid','Circularity','Eccentricity');

% show smallest and biggest
[vmin, argmin] = min(props.Area);
obj = false(size(bw));
obj(cc.PixelIdxList{argmin}) = true;
imshow(obj);

[vmax, argmax] = max(props.Area);
obj = false(size(bw));
obj(cc.PixelIdxList{argmax}) = true;
imshow(obj);


%% show all CCs
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label)

