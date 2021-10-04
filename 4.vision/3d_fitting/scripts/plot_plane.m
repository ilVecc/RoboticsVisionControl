function [] = plot_plane(c,n,xv,yv)

% create plane mesh
[X,Y] = meshgrid(xv, yv);
% z = -(ax + by + d) / c
Z = -( n(1)*X + n(2)*Y + (-n'*c) ) / n(3);

hold on
mesh(X, Y, Z, 'FaceAlpha', 0.5)
hold off

end

