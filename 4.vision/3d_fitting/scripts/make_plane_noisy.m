function [P,xv,yv,c,n] = make_plane_noisy()

[P,xv,yv,c,n] = make_plane();

N = 6*rand(size(P))-3;
P = P + N;

end

