function [T,q,qD,qDD,qDDD,qDDDD] = trigonometric_cycloid(ts,ti,tf,qi,qf)

T = ti:ts:tf;
DQ = qf - qi;
DT = tf - ti;

q = DQ*((T-ti)/DT - 1/(2*pi)*sin(2*pi*(T-ti)/DT)) + qi;
qD = DQ/DT*(1 - cos(2*pi*(T-ti)/DT));
qDD = (2*pi)/DT^2*DQ*sin(2*pi*(T-ti)/DT);
qDDD = (2*pi)^2/DT^3*DQ*cos(2*pi*(T-ti)/DT);
qDDDD = -(2*pi)^3/DT^4*DQ*sin(2*pi*(T-ti)/DT);

end

