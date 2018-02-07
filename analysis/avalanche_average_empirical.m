function Y_t_avg = avalanche_average_empirical(A, B, u_t, T)
%avalanche_average_empirical
%   Calls trigger_avalanche T times & averages the spike counts
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
%   T: max number of trials
% returns
%   Y_t_avg: empirical average neuron firing over time

max_iter = 1e2; % within trial
N = size(A,1);
Y_t_T = zeros(N, max_iter, T);

for trial = 1 : T
    Y_t = trigger_avalanche(A, B, u_t);
    Y_t_T(:, 1:size(Y_t,2), trial) = Y_t;
end
Y_t_avg = mean(Y_t_T, 3);
t_last_firing = find(sum(Y_t_avg, 1), 1, 'last');
Y_t_avg = Y_t_avg(:, 1:t_last_firing);

end

