
%%
p = default_network_parameters;
p.graph_type = 'WS';
p.p_rewire = 1;
A = network_create(p);
g = graph_from_matrix(A);
cycles = grCycleBasis(g.Edges.EndNodes);
histogram(sum(cycles,2))
mean(sum(cycles,2))

%%
