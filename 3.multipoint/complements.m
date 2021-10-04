addpath('..')

ts = 0.01;
qk = [0 2 12 5 12 -10 -11 -4 6 9];
qD0 = 0;
qDn = 0;

%% Time instants: equally spaced
dk = 1/(length(qk)-1) * ones([1 length(qk)-1]);

%% Time instants: cord length
dk = abs(qk(2:end)-qk(1:end-1));

%% Time instants: centripetal distribution
dk = sqrt(abs(qk(2:end)-qk(1:end-1)));

%% Time instants: generic distribution
mu = 3;
dk = abs(qk(2:end)-qk(1:end-1)) .^ (1/mu);
clear mu

%% create trajectory (multipoint: spline by qDD)
tk = [0 cumsum(dk)/sum(dk)];
[~,T,q,qD,qDD,~,~] = multipoint_spline_qDD(ts,tk,qk,qD0,qDn);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);

%% scale to generic time
ti = 2;
tf = 6;
Tk = ti + tk*(tf-ti);

[~,T,q,qD,qDD,~,~] = multipoint_spline_qDD(ts,Tk,qk,qD0,qDn);
plot_profiles(T,q,qD,qDD);
plot_multipoint(Tk,qk);



%% geometric modifications
[~,T,q,~,~,~] = unit_poly_cubic(ts,0,0);
% from (t,q) = (0,0) to (2,1)
T1 = time_scaling(T,2);
q1 = q;
% from (2,1) to (3,-1)
T2 = time_shift(T,2);
q2 = space_scaling(q,1,-1);
% from (3,-1) to (5,0)
T3 = time_shift(time_scaling(T,2),3);
q3 = space_scaling(q,-1,0);

T = [T1 T2 T3];
q = [q1 q2 q3];
plot_profiles(T,q);

function [T] = time_shift(T,t0)
    T = T + t0;
end

function [q] = space_shift(q,q0)
    q = q + q0;
end

function [q] = space_reflection(q)
    q = -q;
end

function [T] = time_scaling(T,t1)
    T = T*t1;
end

function [q] = space_scaling(q,q0,q1)
    q = q0 + (q1-q0)*q;
end

function [a,T,q,qD,qDD,qDDD] = unit_poly_cubic(ts,qDi,qDf)

    a0 = 0;
    a1 = qDi;
    a2 = 3 - (2*qDi+qDf);
    a3 = -2 + (qDi+qDf);

    a = [a3,a2,a1,a0];

    T = 0:ts:1;
    q = a0 + a1*T + a2*T.^2 + a3*T.^3;
    qD = a1 + 2*a2*T + 3*a3*T.^2;
    qDD = 2*a2 + 6*a3*T;
    qDDD = 6*a3*ones(size(T));

end
