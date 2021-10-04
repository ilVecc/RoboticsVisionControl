function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_qDDcmax(ts,ti,DT,qi,qf,qDi,qDf,qDDc_max)
% qDi = qDf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DQ = qf - qi;

if qDDc_max*DQ <= abs(qDi^2-qDf^2)/2
    error('Realization constraint not satisfied: qDDc_max*DQ > abs(qDi^2-qDf^2)/2')
end

qDDc_lim = (2*DQ-(qDi+qDf)*DT+sqrt(4*DQ^2-4*DT*(qDi+qDf)*DT+2*(qDi^2+qDf^2)*DT^2))/DT^2;

if qDDc_max <= qDDc_lim
    error('Maximum acceleration must be bigger than %.3f', qDDc_lim)
end

DDQ = qDf - qDi;
d = qDDc_max^2*DT^2-4*qDDc_max*DQ+2*qDDc_max*(qDi+qDf)*DT-DDQ^2;
qDc = (qDi + qDf + qDDc_max*DT - sqrt(d))/2;
ta = (qDc - qDi)/qDDc_max;
td = (qDc - qDf)/qDDc_max;

[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_generic(ts,ta,td,DT,qi,qf,qDi,qDc,qDf);
T = T + ti;

end

