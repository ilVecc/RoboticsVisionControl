function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_qDcmax_qDDcmax(ts,ti,qi,qf,qDi,qDf,qDc_max,qDDc_max)
% qDi = qDf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DQ = qf - qi;

if qDDc_max*DQ <= abs(qDi^2-qDf^2)/2
    error('Realization constraint not satisfied: qDDc_max*DQ > abs(qDi^2-qDf^2)/2')
end

qDc_lim = sqrt(qDDc_max*DQ+(qDi^2+qDf^2)/2);
qDc = min(qDc_max, qDc_lim);

ta = (qDc - qDi)/qDDc_max;
td = (qDc - qDf)/qDDc_max;
DT = DQ/qDc + qDc/(2*qDDc_max)*((1-qDi/qDc)^2+(1-qDf/qDc)^2);

[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_generic(ts,ta,td,DT,qi,qf,qDi,qDc,qDf);
T = T + ti;

end

