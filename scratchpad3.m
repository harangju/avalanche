

%%
p = default_network_parameters;
p.N = 100;
p.N_in = p.N;
p.graph_type = 'weightedrandom';
p.frac_conn = 0.1;
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.03 0.8 0.9 0.1 0.05 0.01];
p.critical_branching = true;
p.add_noise = false;
p.allow_autapses = false;
p.weigh_by_neuron = true;
[A, B] = network_create(p);

%%
figure(1)
imagesc(A); prettify; colorbar

%% shortest path
[costs, paths] = dijkstra(A>0, 2-A);
paths_loop = cell(1,p.N);
for i = 1 : p.N
    paths_loop{i} = paths{i,i};
end; clear i

%%
prob_tot = ones(1,p.N);
for i = 1 : p.N
    path = paths_loop{i};
    if length(path) == 1
        prob_tot(i) = 0;
        continue
    end
    source = path(1);
    for j = 2 : length(path)
        prob_tot(i) = prob_tot(i) * A(source,path(j));
        source = path(j);
    end
end
clear i j path source
