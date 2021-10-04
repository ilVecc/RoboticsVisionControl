function [a,T,q,qD,qDD,qDDD,qDDDD] = polynomial_linear(ts,ti,tf,qi,qf)

DQ = qf - qi;
DT = tf - ti;

a0 = qi;
a1 = DQ / DT;

a = [a1,a0];

T = 0:ts:DT;
q = a0 + a1*T;
qD = a1 * ones(size(T));
qDD = zeros(size(T));
qDDD = zeros(size(T));
qDDDD = zeros(size(T));

T = ti + T;

end