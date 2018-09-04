function p = default_network_parameters
%default_network_parameters Returns default network parameters in a
%structure
%   Modify fields to customize network
%   Pass param as argument to create_network

p = struct;
p.N = 10;
p.N_in = 10;
p.N_out = 0;
p.N_hidden = 0;
p.frac_conn = 0.1; % fractional connectivity
p.weight_max = 20;
p.weight_min = 0;
p.allow_autapses = false;
% see wu-yan-2018-code > functions > graph generation
p.graph_type = 'weightedrandom';
% see wu-yan-2018-code > functions > edge weighting
p.weighting = 'none';
p.weighting_params = [0.5 0.12]; % parameters for weighting scheme
p.p_rewire = 1e-2; % Pr(rewiring) in Watts-Strogatz network
p.critical_branching = true;
p.add_noise = true;
p.noise_ampl = 1e-7;

end

