%% network parameters
param = default_network_parameters;
param.num_nodes = 30;
param.num_nodes_input = param.num_nodes;
param.num_nodes_output = param.num_nodes;
param.frac_conn = 0.05;
param.graph_type = 'WS';
param.p_rewire = 1;

% p_spike = 1e-4;
dur = 1e3;
iter = 1e4;

