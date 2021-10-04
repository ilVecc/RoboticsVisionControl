function [a,T,q,qD,qDD,qDDD,qDDDD] = polynomial_parabolic_continuous(ts,ti,tf,qi,qf,qDi,qDf)

tm = (tf + ti) / 2;

T = ti:ts:tf;
Ta = T(1:floor(length(T)/2));
Td = T(floor(length(T)/2)+1:end);
DQ = qf - qi;
DT = tf - ti;

% acceleration phase
a0 = qi;
a1 = qDi;
a2 = 2/DT^2*(DQ - qDi*DT) - (qDf - qDi)/(2*DT);

% deceleration phase
a3 = a0 + a1*DT/2 + a2*DT^2/4;
a4 = a1 + a2*DT;
a5 = (qDf - a4)/DT;

a = [a2,a1,a0;
     a5,a4,a3];

q = [a0 + a1*(Ta - ti) + a2*(Ta - ti).^2 ...
     a3 + a4*(Td - tm) + a5*(Td - tm).^2];
qD = [a1 + 2*a2*(Ta - ti) ...
      a4 + 2*a5*(Td - tm)];
qDD = [2*a2*ones(size(Ta)) ...
       2*a5*ones(size(Td))];
qDDD = zeros(size(T));
qDDD(length(Ta)) = (abs(2*a2) + abs(2*a5)) * int8(2*(a2 < a5)-1);
qDDDD = zeros(size(T));

end

