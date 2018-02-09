function param = default_network_parameters
%default_network_parameters Returns default network parameters in a
%structure
%   Modify fields to customize network
%   Pass param as argument to create_network

param = struct;
param.num_nodes = 1e2;
param.frac_conn = 1e-1; % fractional connectivity
param.weight_max = 1;
param.weight_min = 0;
param.allow_autapses = false;
param.graph_type = 'WRG'; % see wu-yan-2018-code > functions > graph generation
param.weighting = 'G'; % see wu-yan-2018-code > functions > edge weighting
param.p_rewire = 1e-2; % Pr(rewiring) in Watts-Strogatz network

end

