% scratchpad.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.num_nodes = 2^8;
p.frac_conn = 1e-2;
p.weight_max = 1.1;
p.graph_type = 'WRG';
[A, B] = create_network(p);

%% Analysis
disp('Analyzing...')
u_t = zeros(p.num_nodes, 1);
[~, idx_max_ave_c] = sort(ave_control(A));
[~, idx_max_mod_c] = sort(modal_control(A));
u_t(idx_max_ave_c(end-2:end), 1) = 1;
Y_t = trigger_avalanche(A, B, u_t);
clf; plot_summary(A, avalanche_size_analytical(A, B, 5),...
    ave_control(A), modal_control(A), Y_t, avalanche_transitions(Y_t, A))
