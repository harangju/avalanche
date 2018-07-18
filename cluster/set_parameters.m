%% network parameters
% param = default_network_parameters;
% param.num_nodes = 30;
% param.num_nodes_input = param.num_nodes;
% param.num_nodes_output = param.num_nodes;
% param.frac_conn = 0.2;
% param.graph_type = 'WS';
% param.p_rewire = 1;

% N = [10 10 10];
% frac_conn = [1 1 1];
% param.num_nodes = sum(N);
% p_rewire = 0;

% set parameters
A0 = [0 1; 1 0]';
B = [1 1]';
N = 2;
redistr = 0.1;

% p_spike = 1e-4;
dur = 3e3;
% iter = 1e4;
iter = 3e3;
