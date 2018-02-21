function mw = desired_mean_weight(sigma, degree)
%desired_mean_weight
%   sigma: desired branching parameter
%   frac_conn: fractional connectivity
%   num_nodes: number of nodes
%   mw: desired mean weight

% num_edges_max = num_nodes * (num_nodes - 1) / 2;
% degree_max = num_edges_max / num_nodes;
% degree = ceil(frac_conn * degree_max);
mw = sigma / degree;

end

