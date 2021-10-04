function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qD_cont_qDD(ts,tk,qk,qD0,qDn)

assert(length(tk) > 2, 'Multipoint trajectory by qD with continuous qDD needs at least 3 points')

% [Tk+1 2(Tk + Tk+1) Tk+1] can be re-written as 
% [tk+2 2*tk+2 tk+1] - [tk+1 2*tk tk] for vectorization
n = length(qk);
TTk = 2*(tk(3:end) - tk(1:end-2));  % [2(T0+T1) 2(T1+T2) ... 2(Tn-2 + Tn-1)]
Tk = tk(2:end) - tk(1:end-1);  % [T0 T1 ... Tn-1]

A = full(spdiags([Tk(1:end-1)' TTk' Tk(2:end)'], -1:1, n-2, n-2))';

% vectorization
Dqk = qk(2:end)-qk(1:end-1);
ck = 3*(Tk(2:end)./Tk(1:end-1).*Dqk(1:end-1) + Tk(1:end-1)./Tk(2:end).*Dqk(2:end));
ck(1) = ck(1)-Tk(2)*qD0;
ck(end) = ck(end)-Tk(end-1)*qDn;

qDk = A\ck';
qDk = [qD0 qDk' qDn];

[A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qD(ts,tk,qk,qDk);

end

