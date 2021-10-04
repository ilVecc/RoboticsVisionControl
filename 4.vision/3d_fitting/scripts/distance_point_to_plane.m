function [d2H,H] = distance_point_to_plane(M,C,D)

d2H = (M-C')*D;  % distance
H = M - d2H*D';  % projection

end

