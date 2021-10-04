function [P,L,c,d] = make_line_noisy()

[P,L,c,d] = make_line();

n = 6*rand(size(P))-3;
P = P + n;

end

