function param = default_network_parameters
%default_network_parameters Returns default network parameters in a
%structure
%   Modify fields to customize network
%   Pass param as argument to create_network

param = struct;
param.num_nodes = 100; % num_nodes = sum of num_nodes_{input|output|hidden}
param.num_nodes_input = param.num_nodes;
param.num_nodes_output = 0;
param.num_nodes_hidden = 0;
param.frac_conn = 1e-1; % fractional connectivity
param.weight_max = 20;
param.weight_min = 0;
param.allow_autapses = false;
param.graph_type = 'WRG'; % see wu-yan-2018-code > functions > graph generation
param.weighting = 'G'; % see wu-yan-2018-code > functions > edge weighting
param.weighting_params = [0.5, 0.12]; % parameters for weighting scheme
param.p_rewire = 1e-2; % Pr(rewiring) in Watts-Strogatz network
param.exp_branching = 1; % desired branching parameter

end

