function [a,T,q,qD,qDD,qDDD,qDDDD] = polynomial_5order(ts,ti,tf,qi,qf,qDi,qDf,qDDi,qDDf)

H = [ 0  0 0 0 0 1;  % qi
      1  1 1 1 1 1;  % qf
      0  0 0 0 1 0;  % qDi
      5  4 3 2 1 0;  % qDf
      0  0 0 2 0 0;  % qDDi
     20 12 6 2 0 0]; % qDDf
Q = [qi,qf,qDi,qDf,qDDi,qDDf]';

a = H\Q;
acell = num2cell(a);
[a5,a4,a3,a2,a1,a0] = acell{:};

DT = tf - ti;
T = 0:ts:DT;
TAU = T/DT;  % T in [0,1]

q = a5*TAU.^5 + a4*TAU.^4 + a3*TAU.^3 + a2*TAU.^2 + a1*TAU + a0;
qD = 5*a5*TAU.^4 + 4*a4*TAU.^3 + 3*a3*TAU.^2 + 2*a2*TAU + a1;
qDD = 20*a5*TAU.^3 + 12*a4*TAU.^2 + 6*a3*TAU + 2*a2;
qDDD = 60*a5*TAU.^2 + 24*a4*TAU + 6*a3;
qDDDD = 120*a5*TAU + 24*a4;
T = T + ti;

end
