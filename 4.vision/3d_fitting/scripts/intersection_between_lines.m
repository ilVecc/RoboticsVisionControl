function [m1,m2,m] = intersection_between_lines(c1,d1,c2,d2)

% calculate L1 and L2 which minimizes distance and the m1 and m2 points
assert(abs(norm(d1-d2)) > 1e-10, 'Lines are parallel (any point is an intersection)')
q = d1'*d2;
Q = (c1-c2)/(1-q);
L1 = q*Q'*d2 - Q'*d1;
m1 = c1 + L1*d1;
L2 = Q'*d2 - q*Q'*d1;
m2 = c2 + L2*d2;

m = mean([m1 m2],2);

end

