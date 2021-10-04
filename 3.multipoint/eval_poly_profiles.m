function [T,q,qD,qDD,qDDD,qDDDD] = eval_poly_profiles(T,a)

aD = polyder(a);
aDD = polyder(aD);
aDDD = polyder(aDD);
aDDDD = polyder(aDDD);

q = polyval(a,T);
qD = polyval(aD,T);
qDD = polyval(aDD,T);
qDDD = polyval(aDDD,T);
qDDDD = polyval(aDDDD,T);

end

