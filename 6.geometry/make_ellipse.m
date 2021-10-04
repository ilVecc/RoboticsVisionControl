function [E,F] = make_ellipse(du,a,b)

angle = 0;

u = 0:du:2*pi;

x = a*cos(u);
y = b*sin(u);
z = zeros(size(u));
E = [x; y; z]';
R = [cosd(angle) -sind(angle) 0;
     sind(angle)  cosd(angle) 0;
               0            0 1];
E = E * R';


t = R * [     -a*sin(u);
               b*cos(u);
         zeros(size(u))] ./ sqrt((a*sin(u)).^2+(b*cos(u)).^2);
n = R * [     -b*cos(u);
              -a*sin(u);
         zeros(size(u))] ./ sqrt((a*sin(u)).^2+(b*cos(u)).^2);
b = R * [zeros(size(u));
         zeros(size(u));
          ones(size(u))];
F = permute(cat(3,t,n,b),[1 3 2]);

end

