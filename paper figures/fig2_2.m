%% simulate diff # nodes
ns = 50 : 50 : 300;
dur = 100;
N = 10;
trials = 1e4;
Ys = cell(length(ns),N);
As = cell(1,length(ns));
for i = 1 : length(ns)
    n = ns(i);
    disp(n)
    p = default_network_parameters;
    p.N = N; p.N_in = N;
    p.frac_conn = 0.2;
    p.graph_type = 'weightedrandom';
    p.weighting = 'uniform'; p.weighting_params = 1;
    p.critical_branching = false;
    p.critical_convergence = true;
    As{i} = network_create(p);
    pats = pings_single(p.N);
    for j = 1 : N
        Ys{i,j} = avl_smp_many({pats{j}},1,A,dur,trials);
    end
end; clear i n A B pats probs
%% 

