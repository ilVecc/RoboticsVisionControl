function [p,v,a,t,n,b] = rectilinear(u,uD,uDD,pi,pf)

p = pi + u.*(pf-pi);
v = uD.*(pf-pi);
a = uDD.*(pf-pi);

end
