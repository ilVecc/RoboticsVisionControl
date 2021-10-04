function [C,F] = make_circle(du,c,r)

u = 0:du:2*pi;

x = c(1) + r*cos(u);
y = c(2) + r*sin(u);
z = zeros(size(u));
C = [x; y; z]';

t = [-sin(u);
      cos(u);
      zeros(size(u))];
n = [-cos(u);
     -sin(u);
      zeros(size(u))];
b = [zeros(size(u));
     zeros(size(u));
      ones(size(u))];
F = permute(cat(3,t,n,b),[1 3 2]);

end
