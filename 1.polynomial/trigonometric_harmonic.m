function [T,q,qD,qDD,qDDD,qDDDD] = trigonometric_harmonic(ts,ti,tf,qi,qf)

T = ti:ts:tf;
DQ = qf - qi;
DT = tf - ti;

q = DQ/2*(1 - cos(pi*(T-ti)/DT)) + qi;
qD = (pi/DT)*DQ/2*sin(pi*(T-ti)/DT);
qDD = (pi/DT)^2*DQ/2*cos(pi*(T-ti)/DT);
qDDD = -(pi/DT)^3*DQ/2*sin(pi*(T-ti)/DT);
qDDDD = -(pi/DT)^4*DQ/2*cos(pi*(T-ti)/DT);

end

