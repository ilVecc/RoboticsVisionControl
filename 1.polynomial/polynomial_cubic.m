function [a,T,q,qD,qDD,qDDD,qDDDD] = polynomial_cubic(ts,ti,tf,qi,qf,qDi,qDf)

DQ = qf - qi;
DT = tf - ti;

a0 = qi;
a1 = qDi;
a2 = (3*DQ - (2*qDi+qDf)*DT)/DT^2;
a3 = (-2*DQ + (qDi+qDf)*DT)/DT^3;

a = [a3,a2,a1,a0];

T = 0:ts:DT;
q = a0 + a1*T + a2*T.^2 + a3*T.^3;
qD = a1 + 2*a2*T + 3*a3*T.^2;
qDD = 2*a2 + 6*a3*T;
qDDD = 6*a3*ones(size(T));
qDDDD = zeros(size(T));
T = T + ti;

end