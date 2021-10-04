% we limit ourselves to linear timing laws
addpath('../1.polynomial')

P = [[0 0 0]' ...
     [1 0 0]' ...
     [2 1 0]' ...
     [2 1 2]' ...
     [2 0 2]'];

%% operational
tc = 0.01;
ti = 0;
DT = 1;

[~,t1,u1,uD1,uDD1] = polynomial_linear(tc,ti,DT+ti,0,1);
[p1, v1, a1] = rectilinear(u1, uD1, uDD1, P(:,1), P(:,2));

[~,t2,u2,uD2,uDD2] = polynomial_linear(tc,t1(end),t1(end)+DT,0,pi/2);
[p2, v2, a2] = circular(u2, uD2, uDD2, P(:,2), [1 1 0]', [0 0 1]');

[~,t3,u3,uD3,uDD3] = polynomial_linear(tc,t2(end),t2(end)+DT,0,pi);
[p3, v3, a3] = circular(u3, uD3, uDD3, P(:,3), [2 1 1]', [1 0 0]');

[~,t4,u4,uD4,uDD4] = polynomial_linear(tc,t3(end),t3(end)+DT,0,1);
[p4, v4, a4] = rectilinear(u4, uD4, uDD4, P(:,4), P(:,5));

% plot everything
p = [p1, p2, p3, p4];
subplot(1,3,1);
plot3(p(1,:),p(2,:),p(3,:),'Color','#0072BD','LineWidth',3);
title('Position');
xlabel('x');
ylabel('y');
zlabel('z');
view(-60, 30);
axis equal;
grid on;

v = [v1, v2, v3, v4];
subplot(1,3,2);
plot3(v(1,:),v(2,:),v(3,:),'Color','#D95319','LineWidth',3);
title('Velocity');
xlabel("x'");
ylabel("y'");
zlabel("z'");
view(-60, 30);
axis equal;
grid on;

a = [a1, a2, a3, a4];
subplot(1,3,3);
plot3(a(1,:),a(2,:),a(3,:),'Color','#7E2F8E','LineWidth',3);
title('Acceleration');
xlabel("x''");
ylabel("y''");
zlabel("z''");
view(-60, 30);
axis equal;
grid on;



%% single components
addpath('../3.multipoint');

ts = 0.1;
tk = [0 1 2 3 4];
xk = P(1,:);
yk = P(2,:);
zk = P(3,:);
W = [+Inf, +Inf, +Inf, +Inf, +Inf];
m una multiplu = 1;
[~,T,x,xD,xDD,~,~] = multipoint_spline_smooth(ts,tk,xk,W,mu);
[~,T,y,yD,yDD,~,~] = multipoint_spline_smooth(ts,tk,yk,W,mu);
[~,T,z,zD,zDD,~,~] = multipoint_spline_smooth(ts,tk,zk,W,mu);

% plot everything
subplot(1,3,1);
hold on;
plot3(x,y,z,'Color','#0072BD','LineWidth',3);
title('Position');
xlabel('x');
ylabel('y');
zlabel('z');
view(-60, 30);
axis equal;
grid on;

subplot(1,3,2);
hold on;
plot3(xD,yD,zD,'Color','#D95319','LineWidth',3);
title('Velocity');
xlabel("x'");
ylabel("y'");
zlabel("z'");
view(-60, 30);
axis equal;
grid on;

subplot(1,3,3);
hold on;
plot3(xDD,yDD,zDD,'Color','#7E2F8E','LineWidth',3);
title('Acceleration');
xlabel("x''");
ylabel("y''");
zlabel("z''");
view(-60, 30);
axis equal;
grid on;



%% plot 
figure;
t = [t1, t2, t3, t4];
subplot(1,2,1);
hold on;
plot(t,p(1,:),'LineWidth',3);
plot(t,p(2,:),'LineWidth',3);
plot(t,p(3,:),'LineWidth',3);
title('Cartesian space');
grid on;

subplot(1,2,2);
hold on;
plot(T,x,'LineWidth',3);
plot(T,y,'LineWidth',3);
plot(T,z,'LineWidth',3);
title('Configuration space');
grid on;

















