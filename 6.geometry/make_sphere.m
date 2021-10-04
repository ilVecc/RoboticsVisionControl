function [X,Y,Z] = make_sphere(c,r)

[X,Y,Z] = sphere(30);
X = X * r + c(1);
Y = Y * r + c(2);
Z = Z * r + c(3);

end

