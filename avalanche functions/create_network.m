function [A, B] = create_network(p)
%create_network Generates network with given parameters
%   p: network parameters, default parameters generated by
%       default_network_parameters()
% returns
%   A: connectivity/weight matrix, [pre- X post-]
%   B: input connectivity/weight vector, [N X 1]

A = 0;
B = ones(p.num_nodes, 1);
% max values
num_edges_max = p.num_nodes * (p.num_nodes - 1) / 2;
degree_max = num_edges_max / p.num_nodes;

% network values
num_edges = ceil(p.frac_conn * num_edges_max);
degree = 2 * ceil(p.frac_conn * degree_max);

switch p.graph_type
    case 'WRG' % weighted random graph
        [~, A] = Weighted_Random_Graph(p.num_nodes, p.frac_conn,num_edges);
    case 'RL' % ring lattice
        [~, A] = Ring_Lattice(p.num_nodes, degree, num_edges);
    case 'WS' % watts-strogatz
        [~, A] = Watts_Strogatz(p.num_nodes, degree, p.p_rewire,num_edges);
    case 'MD2' % modular network with 2 communities
        A = fcn_modular_network(p.num_nodes, num_edges, 2, 0.8);
        warning('what is 0.8')
    case 'MD4'
        A = fcn_modular_network(p.num_nodes, num_edges, 4, 0.8);
    case 'MD8'
        A = fcn_modular_network(p.num_nodes, num_edges, 8, 0.8);
    case 'RG' % random geometric
        A = Thresholded_RG_cube(p.num_nodes, p.frac_conn);
    case 'BA' % Barabasi-Albert
        A = make_BA_edges_weighted(p.num_nodes, num_edges, 0);
    otherwise
        warning('create_network(): undefined graph_type')
end

switch p.weighting
    case 'G' % gaussian
    case 'PL' % power law
    case 'SC' % streamline counts
        warning('create_network(): streamline counts not implemented')
    case 'FA' % fractional anistropy
        warning('create_network(): fractional anistropy not implemented')
    otherwise
        warning('create_network(): undefined weighting')
end

% normalize weighting
warning('create_network: implement min weight')
A = A / max(max(A)) * p.weight_max;

if ~p.allow_autapses
    A = A .* ~diag(ones(p.num_nodes,1));
end

end
