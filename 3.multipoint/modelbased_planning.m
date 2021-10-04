%% model-based trajectory planning
addpath('../../UR5_matlab');

% make trajectory (for simplicity, each joint gets the same)
ts = 0.01;
tk = [0 2 4 8];
qk = [0 pi/2 -pi/2 0];
W = [+Inf +Inf +Inf +Inf];
mu = 1;
q = [];
qD = [];
qDD = [];
for i=1:6
    [~,T,pq,pqD,pqDD,~,~] = multipoint_spline_smooth(ts,tk,qk,W,mu);
    q = [q; pq];
    qD = [qD; pqD];
    qDD = [qDD; pqDD];
end
clear pq pqD pqDD

% get effort
tau = zeros(6, length(T));
dh = get_dh();
G = [0 0 9.81]';
for i=1:length(T)
    tau(:,i) = inv_dyn_recursive_NewtonEulero(dh,q(:,i),qD(:,i),qDD(:,i),G);
end



%% compute scaling
tau_max = [8 10 15 1.5 0.5 0.5];
lambda = sqrt(min(tau_max./abs(max(tau,[],2)')));
qNew = [];
qDNew = [];
qDDNew = [];
for i=1:6
    [~,TNew,pq,pqD,pqDD,~,~] = multipoint_spline_smooth(ts/lambda,tk/lambda,qk,W,mu);
    qNew = [qNew; pq];
    qDNew = [qDNew; pqD];
    qDDNew = [qDDNew; pqDD];
end
clear pq pqD pqDD

% limit effort
tauNew = zeros(6, length(TNew));
for i=1:length(TNew)
    tauNew(:,i) = inv_dyn_recursive_NewtonEulero(dh,qNew(:,i),qDNew(:,i),qDDNew(:,i),G);
end


%% plot q and tau for each joint before and after the scaling
for i=1:6
    subplot(2,3,i);
    hold on;
    plot(T,q(i,:));
    plot(TNew,qNew(i,:));
    hold off;
    title(strcat('Joint q_', num2str(i)))
end
figure;
for i=1:6
    subplot(2,3,i);
    hold on;
    plot(T,tau(i,:));
    plot(TNew,tauNew(i,:));
    plot(TNew,-tau_max(i)*ones(size(TNew)));
    plot(TNew,tau_max(i)*ones(size(TNew)));
    hold off;
    title(strcat('Effort \tau_', num2str(i)))
end
clear i





function dh = get_dh()
    dh.d = [0.089159 0 0 0.10915 0.09465 0.0823];
    dh.m = [3.7000 8.3930 2.2750 1.2190 1.2190 0.1879];
    dh.alpha = [pi/2 0 0 pi/2 -pi/2 0];
    dh.a = [0 -0.42500 -0.39225 0 0 0];
    cm1 = [0.0 -0.02561 0.00193];
    cm2 = [0.2125 0.0 0.11336];
    cm3 = [0.15 0.0 0.0265];
    cm4 = [0.0 -0.0018 0.01634];
    cm5 = [0.0 0.0018 0.01634];
    cm6 = [0.0 0.0 -0.001159];

    dh.cm = [cm1' cm2' cm3' cm4' cm5' cm6'];
    dh.dof = 6;
    dh.issym = false;

    i1 = [0.010267 0.010267 0.00666];
    i2 = [0.2269 0.2269 0.0151];
    i3 = [0.0312168 0.0312168 0.004095];
    i4 = [0.002559898976 0.002559898976 0.0021942];
    i5 = [0.002559898976 0.002559898976 0.0021942];
    i6 = [8.46958911216e-5 8.46958911216e-5 0.0001321171875];

    dh.I = zeros(3, 3, 6);
    dh.I(:,:,1) = [i1(1) 0 0; 0 i1(2) 0; 0 0 i1(3)];
    dh.I(:,:,2) = [i2(1) 0 0; 0 i2(2) 0; 0 0 i2(3)];
    dh.I(:,:,3) = [i3(1) 0 0; 0 i3(2) 0; 0 0 i3(3)];
    dh.I(:,:,4) = [i4(1) 0 0; 0 i4(2) 0; 0 0 i4(3)];
    dh.I(:,:,5) = [i5(1) 0 0; 0 i5(2) 0; 0 0 i5(3)];
    dh.I(:,:,6) = [i6(1) 0 0; 0 i6(2) 0; 0 0 i6(3)];
end