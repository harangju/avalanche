% simulation.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

% step_size = 10e-3; % time (msec)
% t_final = 1; % (sec)
% activity = 1e-2;
% fire_threshold = 1;

% N = 1e2; % number of nodes
% frac_conn = 2e-2; % fraction connectivity
% [~, A] = Weighted_Random_Graph(N, frac_conn/1e1, frac_conn*N*(N-1)/2);
% A = A / max(max(A)) * 0.9;

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.frac_conn = 2e-2;
p.weight_max = 0.9;
[A, B] = create_network(p);

%% Analysis
disp('Analyzing...')
u_t = zeros(p.num_nodes, 1);
[~, idx_max_ave_c] = sort(ave_control(A));
[~, idx_max_mod_c] = sort(modal_control(A));
u_t(idx_max_ave_c(end-1:end), 1) = 1;
Y_t = trigger_avalanche(A, B, u_t);
clf
plot_summary(A, avalanche_size(A, B), ave_control(A), modal_control(A),...
    Y_t, avalanche_transitions(Y_t, A))
