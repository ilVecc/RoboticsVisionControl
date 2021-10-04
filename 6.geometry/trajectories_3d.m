%% distance between lines

[P1,L1,c1,d1] = make_line();
[P2,L2,c2,d2] = make_line();

% plot lines
scatter3(P1(:,1),P1(:,2),P1(:,3),'filled','r');
hold on;
scatter3(P2(:,1),P2(:,2),P2(:,3),'filled','g');
hold off;

% calculate nearest points on each line w.r.t. the other line
[m1,m2,m] = intersection_between_lines(c1,d1,c2,d2);

M = [m1 m2]';
D = norm(m1-m2);

% plot the results
hold on;
scatter3(M(:,1),M(:,2),M(:,3),100,'filled','b');
line(M(:,1),M(:,2),M(:,3),'LineWidth',5,'Color','b')
scatter3(m(1),m(2),m(3),100,'filled','k')
title(sprintf('Distance between lines (blue) is %f\n', D));
clear M
hold off;
axis equal;


%% shortest trajectories on sphere

p0 = rand([3,1]) * 20 - 10;
r = rand() * 5 + 1;

% plot sphere
[X,Y,Z] = make_sphere(p0, r);
surf(X,Y,Z);
daspect([1 1 1]);

% sample points
n_points = 3;
theta = rand([1, n_points]) * pi;
phi = rand([1, n_points]) * 2*pi;
P = p0 + [r.*sin(theta).*cos(phi)
          r.*sin(theta).*sin(phi)
          r.*cos(theta)         ];

hold on;
scatter3(P(1,:),P(2,:),P(3,:),30,'filled','r');
hold off;

% get trajectories
[Pt1, Ft1] = spherical_trajectory(p0,P(:,1),P(:,2),pi/24);
[Pt2, Ft2] = spherical_trajectory(p0,P(:,2),P(:,3),pi/24);
[Pt3, Ft3] = spherical_trajectory(p0,P(:,3),P(:,1),pi/24);

Pt = [Pt1; Pt2; Pt3];
Ft = cat(3, Ft1, Ft2, Ft3);


% plot trajectories
hold on;
scatter3(Pt(:,1),Pt(:,2),Pt(:,3),'filled','b');
scatter3(P(1,:),P(2,:),P(3,:),'filled','r');  % replot
for i=1:size(Ft,3)
    quiver3(Pt(i,1),Pt(i,2),Pt(i,3),Ft(1,1,i),Ft(2,1,i),Ft(3,1,i),'Color','red')
    quiver3(Pt(i,1),Pt(i,2),Pt(i,3),Ft(1,2,i),Ft(2,2,i),Ft(3,2,i),'Color','green')
    quiver3(Pt(i,1),Pt(i,2),Pt(i,3),Ft(1,3,i),Ft(2,3,i),Ft(3,3,i),'Color','blue')
end
hold off;
axis equal;





















