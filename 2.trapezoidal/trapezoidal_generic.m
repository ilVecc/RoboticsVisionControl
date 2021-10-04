function [T,q,qD,qDD,qDDD,qDDDD] = trapezoidal_generic(ts,ta,td,DT,qi,qf,qDi,qDc,qDf)
% qDi != 0, qDf != 0 qDDi = qDDf = 0

assert(0 < ta, 'Acceleration time must be greater than zero')
assert(0 < td, 'Deceleration time must be greater than zero')
assert(ta + td < DT, 'Total time must be greater than %.3f', ta + td)


qDDc = (qDc - qDi)/ta;  % or (qcD - qDf)/td

T = 0:ts:DT;
Ta_idx = find(T>ta,1)-1;
Td_idx = find(T>(DT-td),1)-1;
Ta = T(1:Ta_idx);
Tv = T(Ta_idx+1:Td_idx);
Td = T(Td_idx+1:end);

q = [qi + qDi*Ta + qDDc/2*Ta.^2 ...
     qi + qDi*ta/2 + qDc*(Tv-ta/2) ...
     qf + qDf*(Td-DT) - qDDc/2*(Td-DT).^2];
qD = [qDi + qDDc*Ta ...
      qDc*ones(size(Tv)) ...
      qDf - qDDc*(Td-DT)];
qDD = [qDDc*ones(size(Ta)) ...
       zeros(size(Tv)) ...
       -qDDc*ones(size(Td))];
qDDD = [];
qDDDD = [];

end

