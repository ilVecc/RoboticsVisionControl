function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_smooth(ts,tk,qk,W,mu)

assert(length(tk) > 2, 'Multipoint trajectory by qDD needs at least 2 points')
assert(isvector(W), 'Weights must be provided as a vector')

% s* = min_s (L)  with  L = (q-s)'*W*(q-s) + lambda*SDD'*A*SDD  
%                 and   lambda = (1-mu)/(6*mu)

n = length(qk);

Tk = tk(2:end) - tk(1:end-1);
TTk = 2*([0 Tk] + [Tk 0]);
A = full(spdiags([[Tk 0]' TTk' [0 Tk]'], -1:1, n, n));

invTk = 1./Tk;
invTTk = -([0 invTk] + [invTk 0]);
C = full(spdiags(6*[[invTk 0]' invTTk' [0 invTk]'], -1:1, n, n))';

W(W == 0) = 1e-12;
invW = diag(1./W);

if mu == 0
    sk = null(C'*A\C);  % weird singularity here
    sDDk = A\C*sk;
else
    lambda = (1-mu)/(6*mu);
    sDDk = (A + lambda*C*invW*C')\C*qk';
    sk = qk' - lambda*invW*C'*sDDk;
end

sDDk = sDDk';
sk = sk';

% vectorization
a0 = sk(1:end-1);
a1 = (sk(2:end)-sk(1:end-1))./Tk - (sDDk(2:end)+2*sDDk(1:end-1))/6.*Tk;
a2 = sDDk(1:end-1)/2;
a3 = (sDDk(2:end)-sDDk(1:end-1))./(6*Tk);
A = [a3' a2' a1' a0'];

[A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_generic(ts,tk,A);
    
end
