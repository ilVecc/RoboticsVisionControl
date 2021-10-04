function [T,q,qD,qDD,qDDD,qDDDD] = double_S_DT(ts,ti,DT,a,b,qi,qf)

% ta = td = a*DT, tj1 = tj2 = b*ta

assert(0 < a && a <= 0.5, "'a' coefficient must be between 0 and 1/2")
assert(0 < b && b <= 0.5, "'b' coefficient must be between 0 and 1/2")

DQ = qf - qi;
qDc_max = DQ/((1-a)*DT);
qDDc_max = qDc_max/(a*(1-b)*DT);
qDDDc_max = qDDc_max/(a*b*DT);

qDi = 0;
qDf = 0;

[T,q,qD,qDD,qDDD,qDDDD] = double_S(ts,ti,qi,qf,qDi,qDf,qDc_max,qDDc_max,qDDDc_max);

end
