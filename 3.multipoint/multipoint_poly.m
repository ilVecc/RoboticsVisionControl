function [a,T,q,qD,qDD,qDDD,qDDDD] = multipoint_poly(ts,tk,qk)

V = vander(tk);
a = qk/V';  % not V\qk due to the way vander(.) works

T = tk(1):ts:tk(end);
[~,q,qD,qDD,qDDD,qDDDD] = eval_poly_profiles(T,a);

end

