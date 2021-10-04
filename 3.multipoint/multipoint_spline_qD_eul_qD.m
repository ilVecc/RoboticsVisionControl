function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qD_eul_qD(ts,tk,qk)

Dqk = qk(2:end) - qk(1:end-1);
Tk = tk(2:end) - tk(1:end-1);

% vectorization
v = Dqk./Tk;
% removed "if", replaced with *
qDk = (v(1:end-1) + v(2:end))/2 .* (sign(v(1:end-1)) == sign(v(2:end)));
qDk = [0 qDk 0];

[A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_qD(ts,tk,qk,qDk);

end

