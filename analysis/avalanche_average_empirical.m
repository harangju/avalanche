function [Y_t_avg, transitions] = avalanche_average_empirical(A, B, u_t, T)
%avalanche_average_empirical
%   Calls trigger_avalanche T times & averages the spike counts
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
%   T: max number of trials
% returns
%   Y_t_avg: average neuron firing over time
%   avalanche: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e2; % within trial
N = size(A,1);
Y_t_T = zeros(N, max_iter, T);

for trial = 1 : T
    [Y_t_T(:, :, trial), ~] = trigger_avalanche(A, B, u_t);
end

end

