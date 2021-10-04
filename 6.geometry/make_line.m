function [P,L,c,d] = make_line()

rng('shuffle');

L = -100:0.1:100;
c = randi(300,[3 1])-150;
d = rand([3 1])-0.5;
d = d/norm(d);

P = (c+d*L)';

end
