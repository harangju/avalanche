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
% A0 = [0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 0 0];
% N = 4;
% B = ones(N,1);
% redistr = 0.1;
% seed = 1;
% 

prm = default_network_parameters;
prm.N = 100;
prm.frac_conn = 0.1;
prm.graph_type = 'WRG';

dur = 1e3;
iter = 1e4;
