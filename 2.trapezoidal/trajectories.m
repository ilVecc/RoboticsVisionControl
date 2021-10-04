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


%% Trapezoidal: tc [0,DT]
tc = 1.5;
DT = 5;
[t,q,qD,qDD,~,~] = trapezoidal_simmetric(ts,tc,DT,qi,qf);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: tc [ti,tf]
tc = 1;
[t,q,qD,qDD,~,~] = trapezoidal_tc(ts,ti,tc,tf,qi,qf);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: qDc
qDc = 45;
[t,q,qD,qDD,~,~] = trapezoidal_qDc(ts,ti,tf,qi,qf,qDc);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: qDDc
qDDc = 35;
[t,q,qD,qDD,~,~] = trapezoidal_qDDc(ts,ti,tf,qi,qf,qDDc);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: qDc, qDDc (no tf)
qDc = 25;
qDDc = 40;
[t,q,qD,qDD,~,~] = trapezoidal_qDc_qDDc(ts,ti,qi,qf,qDc,qDDc);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: ta, td [0,DT]
ta = 1.5;
td = 2;
qDc = 15;
[t,q,qD,qDD,~,~] = trapezoidal_generic(ts,ta,td,DT,qi,qf,qDi,qDc,qDf);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: qDDc_max
qDDc_max = 50;
DT = 3;
[t,q,qD,qDD,~,~] = trapezoidal_qDDcmax(ts,ti,DT,qi,qf,qDi,qDf,qDDc_max);
plot_profiles(t,q,qD,qDD);

%% Trapezoidal: qDc_max, qDDc_max (no tf)
qDc_max = 30;
qDDc_max = 50;
[t,q,qD,qDD,~,~] = trapezoidal_qDcmax_qDDcmax(ts,ti,qi,qf,qDi,qDf,qDc_max,qDDc_max);
plot_profiles(t,q,qD,qDD);




%% Double-S: qDc_max, qDDc_max, qDDDc_max (no tf)
qDc_max = 10;
qDDc_max = 3;
qDDDc_max = 5;
[t,q,qD,qDD,qDDD,~] = double_S(ts,ti,qi,qf,qDi,qDf,qDc_max,qDDc_max,qDDDc_max);
plot_profiles(t,q,qD,qDD,qDDD);

%% Double-S: DT, a, b (qDi=qDf=0)
DT = 10;
a = 0.30;
b = 0.25;
[t,q,qD,qDD,qDDD,~] = double_S_DT(ts,ti,DT,a,b,qi,qf);
plot_profiles(t,q,qD,qDD,qDDD);




%% Case study: qf < qi (on Double-S)
ts = 0.01;
ti = 0;
qi = 10;
qf = 5;
qDi = 3;
qDf = 0;
qD_max = 10;
qD_min = -qD_max;
qDD_max = 3;
qDD_min = -qDD_max;
qDDD_max = 5;
qDDD_min = -qDDD_max;

s = sign(qf - qi);
sM = (s+1)/2;
sm = (s-1)/2;

% flip params
new_params = {s*qi, s*qf, ...
              s*qDi, s*qDf, ...
              sM*qD_max + sm*qD_min,     sM*qD_min + sm*qD_max, ...
              sM*qDD_max + sm*qDD_min,   sM*qDD_min + sm*qDD_max, ...
              sM*qDDD_max + sm*qDDD_min, sM*qDDD_min + sm*qDDD_max};
[Sqi, Sqf, ...
 SqDi, SqDf, ...
 SqD_max, SqD_min, ...
 SqDD_max, SqDD_min, ...
 SqDDD_max, SqDDD_min] = new_params{:};
clear new_params

% compute flipped trajectory
[t,Sq,SqD,SqDD,SqDDD,~] = double_S(ts,ti,Sqi,Sqf,SqDi,SqDf,SqD_max,SqDD_max,SqDDD_max);
clear Sqi Sqf SqDi SqDf SqD_max SqD_min SqDD_max SqDD_min SqDDD_max SqDDD_min

% flip flipped trajectory, obtaining the right one
new_traj = {s*Sq, s*SqD, s*SqDD, s*SqDDD};
[q, qD, qDD, qDDD] = new_traj{:};
clear Sq SqD SqDD SqDDD new_traj

plot_profiles(t,q,qD, qDD, qDDD);

% NOTE: 
% we always assumed qDc_max = -qDc_min (same for qDDc_max, qDDDc_max) but
% this time we made it explicit, for the sake of clarity in the formulae.
% Anyway, we actually didn't need to switch the sign for those values, 
% because thanks to max = -min we just obtained the same values as before






