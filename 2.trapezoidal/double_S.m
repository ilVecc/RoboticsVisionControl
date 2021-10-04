function [T,q,qD,qDD,qDDD,qDDDD] = double_S(ts,ti,qi,qf,qDi,qDf,qD_max,qDD_max,qDDD_max)
% qD_max = -qD_min, qDD_max = -qDD_min, qDDD_max = -qDDD_min

assert(qD_max >= qDi && qD_max >= qDf, ...
       'Max speed cannot be smaller than initial/final speed')

DQ = qf - qi;
DDQ = qDf - qDi;

tj_star = min(sqrt(abs(DDQ)/qDDD_max), qDD_max/qDDD_max);

reaches_qDmax = tj_star < qDD_max/qDDD_max;

% case qD_lim = qD_max (... or is it? :) )
if reaches_qDmax
    assert(DQ > tj_star*(qDi+qDf), ...
           'Realization constraint not satisfied: DQ > tj_star*(qDi+qDf)')
    
    % assume qD_lim = qD_max
    % acceleration phase
    if (qD_max-qDi)*qDDD_max < qDD_max^2
        % qDD_max not reached
        tj1 = sqrt((qD_max-qDi)/qDDD_max);
        ta = 2*tj1;
    else
        % qDD_max reached
        tj1 = qDD_max/qDDD_max;
        ta = tj1+(qD_max-qDi)/qDD_max;
    end
    
    % deceleration phase
    if (qD_max-qDf)*qDDD_max < qDD_max^2
        % qDD_min not reached
        tj2 = sqrt((qD_max-qDf)/qDDD_max);
        td = 2*tj2;
    else
        % qDD_min reached
        tj2 = qDD_max/qDDD_max;
        td = tj2+(qD_max-qDf)/qDD_max;
    end
    
    % check feasability again
    tv = DQ/qD_max - ta/2*(1+qDi/qD_max) - td/2*(1+qDf/qD_max);
    if tv < 0
        % everything above is wrong because actually qD_lim < qD_max
        reaches_qDmax = false;
    end
end

% case qD_lim < qD_max
if ~reaches_qDmax
    tj_star = qDD_max/qDDD_max;
    
    assert(DQ > (qDi+qDf)/2*(tj_star+abs(DDQ)/qDDD_max), ...
           'Realization constraint not satisfied: DQ > (qDi+qDf)/2*(tj_star+abs(DDQ)/qDDD_max)')
    
    tj1 = tj_star;
    tj2 = tj_star;
    D = tj_star^2*qDD_max^2+(4*DQ-2*tj_star*(qDi+qDf))*qDD_max+2*(qDi^2+qDf^2);
    ta = (tj_star*qDD_max-2*qDi+sqrt(D))/(2*qDD_max);
    td = (tj_star*qDD_max-2*qDf+sqrt(D))/(2*qDD_max);
    tv = 0;
end

if ta < 0
    % no acceleration phase
    ta = 0; % ?
end

if td < 0
    % no deceleration phase
    td = 0; % ?
end

qDDa_lim = qDDD_max*tj1;
qDDd_lim = -qDDD_max*tj2;
qD_lim = qDi+(ta-tj1)*qDDa_lim; % or = qDf-(Td-Tj2)*qDDd_lim

DT = ta + tv + td;

T = 0:ts:DT;
Tj1_idx = find(T>tj1,1)-1;
Ta_idx = find(T>ta,1)-1;
% acceleration time
Taa = T(1:Tj1_idx);
Tav = T(Tj1_idx+1:(Ta_idx-Tj1_idx+1));
Tad = T((Ta_idx-Tj1_idx+1)+1:Ta_idx);
% constant velocity time
Td_idx = find(T>(DT-td),1)-1;
Tv = T(Ta_idx+1:Td_idx);
% deceleration time
Tj2_idx = find(T>(DT-td+tj2),1)-1;
Tda = T(Td_idx+1:Tj2_idx);
Tdv = T(Tj2_idx+1:end-(Tj2_idx-Td_idx-1));
Tdd = T(end-(Tj2_idx-Td_idx-1)+1:end);

q = [qi + qDi*Taa + qDDD_max/6*Taa.^3 ...
     qi + qDi*Tav + qDDa_lim/6*(3*Tav.^2 - 3*tj1*Tav + tj1.^2) ...
     qi + (qD_lim+qDi)*ta/2 + qD_lim*(Tad-ta) - qDDD_max/6*(Tad-ta).^3 ...
     qi + (qD_lim+qDi)*ta/2 + qD_lim*(Tv-ta) ...
     qf - (qD_lim+qDf)*td/2 + qD_lim*(Tda-DT+td) - qDDD_max/6*(Tda-DT+td).^3 ...
     qf - (qD_lim+qDf)*td/2 + qD_lim*(Tdv-DT+td) + qDDd_lim/6*(3*(Tdv-DT+td).^2 - 3*tj2*(Tdv-DT+td) + tj2.^2) ...
     qf + qDf*(Tdd-DT) + qDDD_max/6*(Tdd-DT).^3];
qD = [qDi + qDDD_max/2*Taa.^2 ...
      qDi + qDDa_lim*(Tav - tj1/2) ...
      qD_lim - qDDD_max/2*(Tad-ta).^2 ...
      qD_lim*ones(size(Tv)) ...
      qD_lim - qDDD_max/2*(Tda-DT+td).^2 ...
      qD_lim + qDDd_lim*((Tdv-DT+td) - tj2/2) ...
      qDf + qDDD_max/2*(Tdd-DT).^2];
qDD = [qDDD_max*Taa ...
       qDDa_lim*ones(size(Tav)) ...
       -qDDD_max*(Tad-ta) ...
       zeros(size(Tv)) ...
       -qDDD_max*(Tda-DT+td) ...
       qDDd_lim*ones(size(Tdv)) ...
       qDDD_max*(Tdd-DT)];
qDDD = [qDDD_max*ones(size(Taa)) ...
       zeros(size(Tav)) ...
       -qDDD_max*ones(size(Tad)) ...
       zeros(size(Tv)) ...
       -qDDD_max*ones(size(Tda)) ...
       zeros(size(Tdv)) ...
       qDDD_max*ones(size(Tdd))];
qDDDD = [];

T = T + ti;

% double-S is basically trapezoidal acceleration, so we can exploit that
%[~,qDa,qDDa,qDDDa,qDDDDa,~] = trapezoidal_simmetric(ts,Tj1,Ta,qDai,qDaf);
%[~,qDd,qDDd,qDDDd,qDDDDd,~] = trapezoidal_simmetric(ts,Tj2,Td,qDdi,qDdf);

end

