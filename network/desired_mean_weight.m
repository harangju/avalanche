function mw = desired_mean_weight(sigma, degree)
%desired_mean_weight
%   sigma: desired branching parameter
%   frac_conn: fractional connectivity
%   num_nodes: number of nodes
%   mw: desired mean weight

% exp_conn = frac_conn * num_nodes * (num_nodes-1) / 2;
% exp_conn_node = exp_conn / num_nodes;
% mw = sigma / exp_conn_node;
mw = sigma / degree;

end

