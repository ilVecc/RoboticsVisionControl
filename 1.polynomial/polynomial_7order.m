function [a,T,q,qD,qDD,qDDD,qDDDD] = polynomial_7order(ts,ti,tf,qi,qf,qDi,qDf,qDDi,qDDf,qDDDi,qDDDf)

H = [   0  0  0  0 0 0 0 1;  % qi
        1  1  1  1 1 1 1 1;  % qf
        0  0  0  0 0 0 1 0;  % qDi
        7  6  5  4 3 2 1 0;  % qDf
        0  0  0  0 0 2 0 0;  % qDDi
       42 30 20 12 6 2 0 0;  % qDDf
        0  0  0  0 6 0 0 0;  % qDDDi
     210 120 60 24 6 0 0 0]; % qDDDf
Q = [qi,qf,qDi,qDf,qDDi,qDDf,qDDDi,qDDDf]';

a = H\Q;
acell = num2cell(a);
[a7,a6,a5,a4,a3,a2,a1,a0] = acell{:};

DT = tf - ti;
T = 0:ts:DT;
TAU = T/DT;  % T in [0,1]

q = a7*TAU.^7 + a6*TAU.^6 + a5*TAU.^5 + a4*TAU.^4 + a3*TAU.^3 + a2*TAU.^2 + a1*TAU + a0;
qD = 7*a7*TAU.^6 + 6*a6*TAU.^5 + 5*a5*TAU.^4 + 4*a4*TAU.^3 + 3*a3*TAU.^2 + 2*a2*TAU + a1;
qDD = 42*a7*TAU.^5 + 30*a6*TAU.^4 + 20*a5*TAU.^3 + 12*a4*TAU.^2 + 6*a3*TAU + 2*a2;
qDDD = 210*a7*TAU.^4 + 120*a6*TAU.^3 + 60*a5*TAU.^2 + 24*a4*TAU + 6*a3;
qDDDD = 840*a7*TAU.^3 + 360*a6*TAU.^2 + 120*a5*TAU + 24*a4;
T = T + ti;

end
