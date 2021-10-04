function [P,xv,yv,c,n] = make_plane()

rng('shuffle');

c = randi(300,[3 1])-150;
n = rand([3 1])-0.5;
n = n/norm(n);

xv = -100:100;
yv = -100:100;
[X,Y] = meshgrid(xv, yv);
% z = -(ax + by + d) / c
Z = -( n(1)*X + n(2)*Y + (-n'*c) ) / n(3);

P = reshape(cat(3,X,Y,Z),[],3);

end
