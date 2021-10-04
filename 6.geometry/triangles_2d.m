%% setup environment

% line parameters
t = 30;
d = [cosd(t) sind(t)]';
p0 = [3 3]';

p = p0 + d * 3;  % on the line
q = [3 6]';      % outside the line

% just two points in order to plot the line
L = [p0 + d * (-5) ...
     p0 + d * ( 10)]';

% plot everything
scatter(p0(1),p0(2),'b');
hold on;
quiver(0,0,d(1),d(2),'Color','b');
scatter(p(1),p(2),'r');
scatter(q(1),q(2),'r');
line(L(:,1),L(:,2),'Color','b');
hold off;
grid on;
daspect([1 1 1]);



%% find points for triangle with area 5

% we know that  A = |p-h|*|q-Q|/2  where Q is the projection of q on line L
% we also know that  h = p0 + Lh*d  where Lh is a scalar

% wanted area
A = 5;

Lh = norm(p-p0) + [1 -1] * 2*A/dist_line(q',p0,d);  % we have two solutions!
h = (p0 + d * Lh)';
Q = p0 + ((q-p0)'*d)*d;

hold on;
scatter(Q(1),Q(2),'g');
scatter(h(:,1),h(:,2),'k');
L = [p q h(1,:)' p]';
line(L(:,1),L(:,2),'Color','black');
L = [p q h(2,:)' p]';
line(L(:,1),L(:,2),'Color','black');
hold off;
clear L





%% find points for isoscelis triangle

% we know that  h = p+2*(Q-p)  where Q is the projection of q on line L

Q = p0 + ((q-p0)'*d)*d;
h = 2*Q - p;  % just one solution here :)

hold on;
scatter(Q(1),Q(2),'g');
scatter(h(1),h(2),'k');
L = [p q h p]';
line(L(:,1),L(:,2),'Color','black');
hold off;
clear L

