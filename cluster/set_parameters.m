%% network parameters
param = default_network_parameters;
param.num_nodes = 100;
param.num_nodes_input = param.num_nodes;
param.num_nodes_output = param.num_nodes;
param.frac_conn = 0.1;
param.graph_type = 'WRG';
param.exp_branching = 1;

p_spike = 1e-4;
iter = 1e6;
