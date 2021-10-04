function [A,T,q,qD,qDD,qDDD,qDDDD] = multipoint_spline_generic(ts,tk,A)

assert(length(tk) > 1, 'Multipoint trajectory needs at least 2 points')

T = tk(1):ts:tk(end);
q = zeros(size(T));
qD = zeros(size(T));
qDD = zeros(size(T));
qDDD = zeros(size(T));
qDDDD = zeros(size(T));

prev_cut = zeros(size(T));
for k=2:length(tk)
    curr_cut = T<=tk(k);
    sel = xor(prev_cut, curr_cut);
    prev_cut = curr_cut;
    Tk = T(sel);
    [~,qk,qDk,qDDk,qDDDk,qDDDDk] = eval_poly_profiles(Tk-tk(k-1),A(k-1,:));
    q(sel) = qk;
    qD(sel) = qDk;
    qDD(sel) = qDDk;
    qDDD(sel) = qDDDk;
    qDDDD(sel) = qDDDDk;
end

end

