function [] = plot_profiles(t,q,qD,qDD,qDDD,qDDDD)

n_funs = 0;
if exist('q', 'var') && ~isempty(q)
    n_funs = n_funs + 1;
end
if exist('qD', 'var') && ~isempty(qD)
    n_funs = n_funs + 1;
end
if exist('qDD', 'var') && ~isempty(qDD)
    n_funs = n_funs + 1;
end
if exist('qDDD', 'var') && ~isempty(qDDD)
    n_funs = n_funs + 1;
end
if exist('qDDDD', 'var') && ~isempty(qDDDD)
    n_funs = n_funs + 1;
end

curr_idx = 1;
if exist('q', 'var') && ~isempty(q)
    subplot(n_funs,1,curr_idx), plot(t, q), ylabel({'Position';'[m]'});
    curr_idx = curr_idx + 1;
end
if exist('qD', 'var') && ~isempty(qD)
    subplot(n_funs,1,curr_idx), plot(t, qD), ylabel({'Speed';'[m/s]'});
    curr_idx = curr_idx + 1;
end
if exist('qDD', 'var') && ~isempty(qDD)
    subplot(n_funs,1,curr_idx), plot(t, qDD), ylabel({'Acceleration';'[m/s^2]'});
    curr_idx = curr_idx + 1;
end
if exist('qDDD', 'var') && ~isempty(qDDD)
    subplot(n_funs,1,curr_idx), plot(t, qDDD), ylabel({'Jerk';'[m/s^3]'});
    curr_idx = curr_idx + 1;
end
if exist('qDDDD', 'var') && ~isempty(qDDDD)
    subplot(n_funs,1,curr_idx), plot(t, qDDDD), ylabel({'Snap';'[m/s^4]'});
end
xlabel('Time [s]');

end

