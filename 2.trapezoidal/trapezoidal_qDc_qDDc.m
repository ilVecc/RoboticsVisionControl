function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_qDc_qDDc(ts,ti,qi,qf,qDc,qDDc)
% qi = qf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DQ = qf - qi;
tc = qDc/qDDc;
DT = tc + DQ/qDc;

[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_simmetric(ts,tc,DT,qi,qf);
T = T + ti;

end

