function [Y_t_avg, Y_t_var] = avalanche_average_empirical(A, B, u_t,...
    num_trials, max_duration)
%avalanche_average_empirical
%   Calls trigger_avalanche T times & averages the spike counts
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
%   num_trials: max number of trials
%   max_duration: max avalanche duration
% returns
%   Y_t_avg: empirical average neuron firing over time

N = size(A,1);
Y_t_trials = zeros(N, max_duration, num_trials);

for trial = 1 : num_trials
    Y_t = trigger_avalanche(A, B, u_t, max_duration);
    Y_t_trials(:, 1:size(Y_t,2), trial) = Y_t;
end
Y_t_avg = mean(Y_t_trials, 3);
Y_t_var = var(Y_t_trials, 0, 3);
t_last_firing = find(sum(Y_t_avg, 1), 1, 'last');
Y_t_avg = Y_t_avg(:, 1:max_duration);
Y_t_var = Y_t_var(:, 1:max_duration);

end

