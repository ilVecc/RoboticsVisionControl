function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qD(ts,tk,qk,qDk)

assert(length(tk) > 1, 'Multipoint trajectory by qDD needs at least 2 points')

Tk = tk(2:end) - tk(1:end-1);
Dqk = (qk(2:end)-qk(1:end-1))./Tk;

% vectorization
a0 = qk(1:end-1);
a1 = qDk(1:end-1);
a2 = (3*Dqk - 2*qDk(1:end-1) - qDk(2:end))./Tk;
a3 = (-2*Dqk + qDk(1:end-1) + qDk(2:end))./Tk.^2;
A = [a3' a2' a1' a0'];

[A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_generic(ts,tk,A);

end
