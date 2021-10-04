function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_qDc(ts,ti,tf,qi,qf,qDc)
% qi = qf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DQ = qf - qi;
DT = tf - ti;

min_qDc = DQ/DT;
max_qDc = 2*DQ/DT;
if qDc <= min_qDc || qDc > max_qDc
    error('Cut speed must be between %.3f and %.3f', min_qDc, max_qDc)
end

tc = DT - DQ/qDc;
[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_tc(ts,ti,tc,tf,qi,qf);

end

