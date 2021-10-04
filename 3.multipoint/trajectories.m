%% Include scripts
addpath('..')

ts = 0.01;

%% Multipoint: polynomial
tk = [0 2 6  7 10];
qk = [3 7 8 -3 -1];

[a,T,q,qD,qDD,~,~] = multipoint_poly(ts,tk,qk);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);

%% Multipoint: spline by qD: approx qD
tk = [0 2 6];
qk = [3 7 8];

[A,T,q,qD,qDD,~,~] = multipoint_spline_qD_eul_qD(ts,tk,qk);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);

%% Multipoint: spline by qD: continuous qDD
tk = [0 2 6  7 10];
qk = [3 7 8 11 20];
qD0 = 0;
qDn = 0;

[A,T,q,qD,qDD,~,~] = multipoint_spline_qD_cont_qDD(ts,tk,qk,qD0,qDn);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);

%% Multipoint: spline by qDD
% same as "spline by qD: continuous qDD", just derived using qDD
tk = [0 2 6  7 10];
qk = [3 15 8 11 20];
qD0 = 0;
qDn = 5;

[A,T,q,qD,qDD,~,~] = multipoint_spline_qDD(ts,tk,qk,qD0,qDn);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);

%% Multipoint: spline smooth
% quasi-same as "spline by qDD", only when mu = 1
tk = [0 2 6  7 10];
qk = [3 15 8 11 20];
W = [+Inf 3 0.5 1 +Inf];
mu = 0.5;

[A,T,q,qD,qDD,~,~] = multipoint_spline_smooth(ts,tk,qk,W,mu);
plot_profiles(T,q,qD,qDD);
plot_multipoint(tk,qk);










