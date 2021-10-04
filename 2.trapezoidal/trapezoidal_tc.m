function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_tc(ts,ti,tc,tf,qi,qf)
% qDi = qDf = 0, ta = td = tc

% we calculate everything on [0,DT] and then add ti to T to obtain [ti,tf]

DT = tf - ti;
%assert(ti < tc && tc < ti + DT/2,'Cut speed must be between %.3f and %.3f', ti, ti+DT/2)

[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_simmetric(ts,tc,DT,qi,qf);
T = T + ti;

end

