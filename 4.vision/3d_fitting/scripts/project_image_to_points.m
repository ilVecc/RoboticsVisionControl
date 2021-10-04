function [P] = project_image_to_points(I,depth,mask)

[n, m] = size(mask);
[x, y] = meshgrid(1:m, 1:n);
% computer 3D points
Zc = double(depth(mask));
Xc = (x(mask)-I.u0).*Zc/I.fx;
Yc = (y(mask)-I.v0).*Zc/I.fy;

P = [Xc, Yc, Zc];

end

