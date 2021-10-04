function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_simmetric(ts,tc,DT,qi,qf)
% qDi = qDf = 0, ta = td = tc, ti = 0

if tc < 0 || tc > DT/2
    error('Cut speed must be between %.3f and %.3f', 0, DT/2)
end

DQ = qf - qi;
qDc = DQ/(DT-tc);
[T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_generic(ts,tc,tc,DT,qi,qf,0,qDc,0);

end


