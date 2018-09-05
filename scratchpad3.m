

%%
p = default_network_parameters;
p.N = 5;
p.N_in = p.N;
p.graph_type = 'weightedrandom';
p.frac_conn = 0.8;
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
A_ = 2*(A>0)-A;
A_(A_==0) = inf;
for i = 1 : p.N
    [cost route] = dijkstra(A_, i, i);
    disp(route)
    pause
end

