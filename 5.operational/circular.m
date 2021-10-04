function [p,v,a,t,n,b] = circular(u,uD,uDD,Pi,c,r)

x = Pi - c;
y = cross(r,x);
assert(norm(cross(x,y) - r) < 1e-10, "Axis provided is not within the possible ones");

R = [x y r];
ro = norm(x);

p = c + R*[     ro*cos(u); 
                ro*sin(u); 
           zeros(size(u))];
v = R*(uD.*[    -ro*sin(u); 
                 ro*cos(u); 
            zeros(size(u))]);
a = R*(uDD.*[    -ro*sin(u); 
                  ro*cos(u); 
             zeros(size(u))] ...
       +uD.*[    -ro*cos(u); 
                 -ro*sin(u); 
             zeros(size(u))]);

end
