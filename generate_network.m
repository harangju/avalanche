
%% generate network from data
load('beggs data/DataSet2.mat')
A = estimate_network_from_spikes(data, 0.1);
B = double(outdegree(A)>0);
A = scale_weights_to_criticality(A);
beep

%% generate network with random connections
p = default_network_parameters;
p.num_nodes = 10;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.33;
p.graph_type = 'WRG';
p.exp_branching = 1;
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);

%%
g = graph_from_matrix(A);
plot(g)
prettify