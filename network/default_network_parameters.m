function param = default_network_parameters
%default_network_parameters Returns default network parameters in a
%structure
%   Modify fields to customize network
%   Pass param as argument to create_network

param = struct;
param.N = 10;
param.N_in = 10;
param.N_out = 0;
param.N_hidden = 0;
param.frac_conn = 0.1; % fractional connectivity
param.weight_max = 20;
param.weight_min = 0;
param.allow_autapses = false;
% see wu-yan-2018-code > functions > graph generation
param.graph_type = 'weightedrandom';
% see wu-yan-2018-code > functions > edge weighting
param.weighting = 'gaussian';
param.weighting_params = [0.5, 0.12]; % parameters for weighting scheme
param.p_rewire = 1e-2; % Pr(rewiring) in Watts-Strogatz network
param.critical_branching = true;

end

