%% Include scripts
addpath('..')

%% Parameters
ti = 2;  %[s]
tf = 5; %[s]

qi = 25;  %[m]
qf = 100; %[m]

qDi = 5; %[m/s]
qDf = 0; %[m/s]

qDDi = 20; %[m/s^2]
qDDf = -10; %[m/s^2]

qDDDi = 1100; %[m/s^3]
qDDDf = 0; %[m/s^3]

ts = 0.01;


%% Polynomial: linear
[~,t,q,qD,qDD,~,~] = polynomial_linear(ts,ti,tf,qi,qf);
plot_profiles(t,q,qD,qDD);

%% Polynomial: parabolic
[~,t,q,qD,qDD,qDDD,~] = polynomial_parabolic(ts,ti,tf,qi,qf,qDi,qDf);
plot_profiles(t,q,qD,qDD,qDDD);

%% Polynomial: parabolic (continuous qD in tm)
[~,t,q,qD,qDD,qDDD,~] = polynomial_parabolic_continuous(ts,ti,tf,qi,qf,qDi,qDf);
plot_profiles(t,q,qD,qDD,qDDD);

%% Polynomial: cubic
[~,t,q,qD,qDD,qDDD,~] = polynomial_cubic(ts,ti,tf,qi,qf,qDi,qDf);
plot_profiles(t,q,qD,qDD,qDDD);

%% Polynomial: 5th order
[~,t,q,qD,qDD,qDDD,qDDDD] = polynomial_5order(ts,ti,tf,qi,qf,qDi,qDf,qDDi,qDDf);
plot_profiles(t,q,qD,qDD,qDDD,qDDDD);

%% Polynomial: 7th order
[~,t,q,qD,qDD,qDDD,qDDDD] = polynomial_7order(ts,ti,tf,qi,qf,qDi,qDf,qDDi,qDDf,qDDDi,qDDDf);
plot_profiles(t,q,qD,qDD,qDDD,qDDDD);

%% Trigonometric: harmonic
[t,q,qD,qDD,qDDD,qDDDD] = trigonometric_harmonic(ts,ti,tf,qi,qf);
plot_profiles(t,q,qD,qDD,qDDD,qDDDD);

%% Trigonometric: cycloid
[t,q,qD,qDD,qDDD,qDDDD] = trigonometric_cycloid(ts,ti,tf,qi,qf);
plot_profiles(t,q,qD,qDD,qDDD,qDDDD);












