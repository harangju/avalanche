%% simulate graph types
% ns = 50 : 50 : 300;
graph_types = {'weightedrandom','ringlattice','mod4comm','wattsstrogatz'};
trials = 30;
dur = 100;
N = 12;
trials = 1e4;
Ys = cell(length(graph_types),trials,N);
As = cell(length(graph_types),trials);
for i = 1 : length(graph_types)
    for j = 1 : trials
    p = default_network_parameters;
    p.N = N; p.N_in = N;
    p.frac_conn = 0.2;
    p.graph_type = graph_types{i};
    p.weighting = 'uniform'; p.weighting_params = 1;
    p.critical_branching = false;
    p.critical_convergence = true;
    As{i} = network_create(p);
    pats = pings_single(p.N);
    for k = 1 : N
        Ys{i,j,k} = avl_smp_many({pats{k}},1,As{i},dur,trials);
    end
    end
end; clear i n A B pats probs
%% 

