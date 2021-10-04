addpath('scripts');

%% plane fitting

[P,xv,yv] = make_plane_noisy();
scatter3(P(:,1),P(:,2),P(:,3),'.');

[c,n] = fit_plane(P);

% plot estimated plane
plot_plane(c,n,xv,yv);
clear xv yv


%% point-to-plane distance and projection
m = 2;
M = repmat(mean(P,1),[m,1]) + 50*rand([m,3])-25;

[D,H] = distance_point_to_plane(M,c,n);

plot_projections(M,H);


%% line fitting

[P,L] = make_line_noisy();
scatter3(P(:,1),P(:,2),P(:,3),5,'filled')

[c,d] = fit_line_pca(P);

% plot estimated line
Pe = (c+d*L)';
hold on;
line(Pe(:,1),Pe(:,2),Pe(:,3),'LineWidth',5,'Color','r');
hold off;
clear Pe


%% point-to-line distance and projection
m = 2;
M = repmat(c',[m,1]) + 50*rand([m,3])-25;

[D,H] = distance_point_to_line(M,c,d);

plot_projections(M,H);


%% angle between two lines

rng('shuffle');
% create two lines
[P1,~,~,d1] = make_line();
[P2,~,~,d2] = make_line();

scatter3(P1(:,1),P1(:,2),P1(:,3),'filled','r');
hold on;
scatter3(P2(:,1),P2(:,2),P2(:,3),'filled','g');
hold off;

a = angle_between_lines(d1,d2);


%% intersection between two lines

rng('shuffle');
% create two lines
[P1,~,c1,d1] = make_line();
[P2,~,c2,d2] = make_line();

scatter3(P1(:,1),P1(:,2),P1(:,3),'filled','r');
hold on;
scatter3(P2(:,1),P2(:,2),P2(:,3),'filled','g');
hold off;

[m1,m2,m] = intersection_between_lines(c1,d1,c2,d2);

M = [m1 m2]';
D = norm(m1-m2);

hold on;
scatter3(M(:,1),M(:,2),M(:,3),100,'filled','b');
line(M(:,1),M(:,2),M(:,3),'LineWidth',5,'Color','b')
scatter3(m(1),m(2),m(3),100,'filled','k')
clear M
hold off;


%% robust line fitting using RANSAC

[P,L,c,d] = make_line_noisy();

scatter3(P(:,1),P(:,2),P(:,3),5,'filled')

% RANSAC
[best_C, best_D] = ransac(P,1000,3,2, @fit_line_pca, @distance_point_to_line);

% plot best line
plot_line(best_C,best_D,L);
