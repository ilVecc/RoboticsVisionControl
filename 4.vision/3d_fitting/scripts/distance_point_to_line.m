function [d2H,H] = distance_point_to_line(M,C,D)

h = cross(repmat(D',[size(M,1),1]),(M-C'),2);
d2H = vecnorm(h,2,2);  % distance
H = M + cross(repmat(D',[size(M,1),1]),h,2);  % projection

end
