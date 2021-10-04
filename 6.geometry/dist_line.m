function [D] = dist_line(P,p0,d)

D = vecnorm((P'-p0)-((P-p0')*d)*d, 2,1)';

end

