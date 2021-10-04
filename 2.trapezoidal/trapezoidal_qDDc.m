function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_qDDc(ts,ti,tf,qi,qf,qDDc)
% qi = qf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DQ = qf - qi;
DT = tf - ti;

min_qDDc = 4*DQ/DT^2;
if qDDc < min_qDDc
    error('Cut acceleration must be greater than %.3f', min_qDDc)
end

tc = DT/2 - sqrt(DT^2-4*DQ/qDDc)/2;
[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_tc(ts,ti,tc,tf,qi,qf);
T = T + ti;

end

