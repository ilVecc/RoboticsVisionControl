function [img] = project_points_to_image(I,P,Pcol,n,m)

% NOT WORKING

x = uint8(I.fx*P(:,1)./P(:,3));
y = uint8(I.fy*P(:,2)./P(:,3));

% add color
img = zeros([n m 3]);
tmp(sub2ind([n m],x,y)) = uint8(Pcol(:,1)*255);
img(:,:,1) = tmp;
img(x,y,2) = uint8(Pcol(:,2)*255);
img(x,y,3) = uint8(Pcol(:,3)*255);

end

