function A = network_connect(type, num_nodes, ...
    frac_conn, num_edges, degree, p_rewire)
%connect_graph Returns connectivity matrix A [pre- X post-]
%   called by network_create

switch type
    case 'WRG' % weighted random graph
        [~, A] = Weighted_Random_Graph(num_nodes, frac_conn, num_edges);
    case 'RL' % ring lattice
        [~, A] = Ring_Lattice(num_nodes, degree, num_edges);
    case 'WS' % watts-strogatz
        [~, A] = Watts_Strogatz(num_nodes, degree, p_rewire,  num_edges);
    case 'MD2' % modular network with 2 communities
        A = fcn_modular_network(num_nodes, num_edges, 2, 0.8);
        warning('modular network: what is 0.8')
    case 'MD4'
        A = fcn_modular_network(num_nodes, num_edges, 4, 0.8);
    case 'MD8'
        A = fcn_modular_network(num_nodes, num_edges, 8, 0.8);
    case 'RG' % random geometric
        A = Thresholded_RG_cube(num_nodes, frac_conn);
    case 'BA' % Barabasi-Albert
        A = make_BA_edges_weighted(num_nodes, num_edges, 0);
    otherwise
        A = 0;
        warning('create_network(): undefined graph_type')
end
end

