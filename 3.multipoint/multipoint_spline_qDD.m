function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qDD(ts,tk,qk,qD0,qDn)

assert(length(tk) > 2, 'Multipoint trajectory by qDD needs at least 2 points')

n = length(qk);

Tk = tk(2:end) - tk(1:end-1);
TTk = 2*([0 Tk] + [Tk 0]);
A = full(spdiags([[Tk 0]' TTk' [0 Tk]'], -1:1, n, n))';

Dqk = (qk(2:end)-qk(1:end-1))./Tk;
ck = 6*([Dqk qDn] - [qD0 Dqk]);

qDDk = A\ck';
qDDk = qDDk';


Tk = tk(2:end) - tk(1:end-1);

% vectorization
a0 = qk(1:end-1);
a1 = Dqk - (qDDk(2:end)+2*qDDk(1:end-1))/6.*Tk;
a2 = qDDk(1:end-1)/2;
a3 = (qDDk(2:end)-qDDk(1:end-1))./(6*Tk);
A = [a3' a2' a1' a0'];

[A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_generic(ts,tk,A);

end
