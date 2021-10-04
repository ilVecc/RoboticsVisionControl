function [P,F] = make_parabola(u,a,b,c)

angle = 0;

x = u;
y = (a*u.^2 + b*u + c);
z = zeros(size(u));
P = [x; y; z]';
R = [cosd(angle) -sind(angle) 0;
     sind(angle)  cosd(angle) 0;
               0            0 1];
P = P * R';


% s(t) = (arcosh(2at+b)-arcosh(b)+(2at+b)*srqt((2at+b)^2-1)-b*sqrt(b^2-1))/4a


t = R * [ ones(size(u));
                2*a*u+b;
         zeros(size(u))] ./ sqrt(1+(2*a*u+b).^2);
n = R * [    -(2*a*u+b);
          ones(size(u));
         zeros(size(u))] ./ sqrt(1+(2*a*u+b).^2);
b = R * [zeros(size(u));
         zeros(size(u));
          ones(size(u))];
F = permute(cat(3,t,n,b),[1 3 2]);

end

