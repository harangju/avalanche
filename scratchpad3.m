
%%
param = default_network_parameters;
param.num_nodes = 30;
param.num_nodes_input = param.num_nodes;
param.num_nodes_output = param.num_nodes;
param.frac_conn = 0.05;
param.graph_type = 'WRG';
param.p_rewire = 1;

A = network_create(param);
A = scale_weights_to_criticality(A);

%%
g = graph_from_matrix(A);
e = g.Edges.EndNodes;
w = g.Edges.Weight;

%%
clearvars -except e w
