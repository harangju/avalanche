% scratchpad.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.num_nodes = 300;
p.num_nodes_input = 100;
p.num_nodes_output = 100;
p.num_nodes_hidden = 100;
p.frac_conn = 2e-2;
p.graph_type = 'WRG';
p.exp_branching = 1;
% p.weighting_params(1) = 0.1;
[A, B, C] = network_create(p);

%% Analysis
disp('Analyzing...')
sig = branching(A);
disp(['avg branching parameter: ' num2str(mean(sig)) '+-' ...
    num2str(std(sig)/p.num_nodes)])
u_t = zeros(p.num_nodes, 1);
[~, idx_max_ave_c] = sort(ave_control(A));
[~, idx_max_mod_c] = sort(modal_control(A));
u_t(idx_max_ave_c(end-1:end), 1) = 1;
Y_t = trigger_avalanche(A, B, u_t, 10);
clf; plot_summary(A, avalanche_size_analytical(A, B, 5),...
    ave_control(A), modal_control(A), Y_t, avalanche_transitions(Y_t, A))
