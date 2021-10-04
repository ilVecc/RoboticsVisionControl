%% Frenet frame of circle

% make circle
c = [3 4]';
r = 5;
[C,F] = make_circle(pi/24,c,r);

plot(C(:,1),C(:,2));

% plot frames
hold on;
for i=1:size(F,3)
    quiver3(C(i,1),C(i,2),C(i,3),F(1,1,i),F(2,1,i),F(3,1,i),'Color','red')
    quiver3(C(i,1),C(i,2),C(i,3),F(1,2,i),F(2,2,i),F(3,2,i),'Color','green')
    quiver3(C(i,1),C(i,2),C(i,3),F(1,3,i),F(2,3,i),F(3,3,i),'Color','blue')
end
hold off;
view(45,45);
grid on;
daspect([1 1 1]);


%% Frenet frame of parabola

% make parabola
[P,F] = make_parabola(-3:0.1:3,1,0,0);

plot(P(:,1),P(:,2));

% plot frames
hold on;
for i=1:size(F,3)
    quiver3(P(i,1),P(i,2),P(i,3),F(1,1,i),F(2,1,i),F(3,1,i),'Color','red')
    quiver3(P(i,1),P(i,2),P(i,3),F(1,2,i),F(2,2,i),F(3,2,i),'Color','green')
    quiver3(P(i,1),P(i,2),P(i,3),F(1,3,i),F(2,3,i),F(3,3,i),'Color','blue')
end
hold off;
view(45,45);
grid on;
daspect([1 1 1]);


%% Frenet frame of ellipse

% make ellipse
a = 3;
b = 5;
[C,F] = make_ellipse(pi/24,a,b);

plot(C(:,1),C(:,2));

% plot frames
hold on;
C = [C zeros([size(C,1) 1])];
for i=1:size(F,3)
    quiver3(C(i,1),C(i,2),C(i,3),F(1,1,i),F(2,1,i),F(3,1,i),'Color','red')
    quiver3(C(i,1),C(i,2),C(i,3),F(1,2,i),F(2,2,i),F(3,2,i),'Color','green')
    quiver3(C(i,1),C(i,2),C(i,3),F(1,3,i),F(2,3,i),F(3,3,i),'Color','blue')
end
hold off;
view(45,45);
grid on;
daspect([1 1 1]);

