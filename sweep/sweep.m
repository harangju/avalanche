% sweep.m
% Written by Harang Ju. March 3, 2018.

% loop
% update parameters
% measure

% nodes = [2 4 8 16 32 64];
nodes = [2 4 8 16 32 64];
% conn = [0.9 0.3 0.1 0.03 0.01 0.003];
conn = [0.9 0.3 0.1 0.03 0.01 0.003];
% graph = {'WRG' 'RL' 'WS' 'MD2' 'MD4' 'MD8' 'RG' 'BA'};
graph = {'WRG' 'RG' 'BA'};
branch = [0.2 0.6 1.0 1.4 1.8 2.2 2.6 3.0 3.4 3.8 4.2];
iter = 1e1;
ping_iter = 1e3; ping_dur = 10;
mi_mean = zeros(length(nodes),length(conn),length(graph),length(branch));
mi_top = zeros(size(mi_mean));
mi_min = zeros(size(mi_mean));
mi_std = zeros(size(mi_mean));
mi_time = zeros(size(mi_mean));

for n = 1 : length(nodes)
for c = 1 : length(conn)
for g = 1 : length(graph)
for b = 1 : length(branch)
    for i = 1 : iter
        r = ['n ' num2str(n) ' c ' num2str(c) ' g ' num2str(g)...
            ' b ' num2str(b) ' i ' num2str(i)];
        disp(r)
        p = default_network_parameters;
        p.num_nodes = nodes(n);
        p.num_nodes_input = p.num_nodes;
        p.num_nodes_output = p.num_nodes;
        p.frac_conn = conn(c);
        p.graph_type = graph{g};
        p.exp_branching = branch(b);
        disp('creating network...')
        [A, B, C] = network_create(p);
        disp('pinging nodes...')
        [Y, pat] = ping_nodes(A, B, ping_iter, ping_dur);
        disp('calculating mutual information...')
        mi_info = mutual_info(Y, pat);
        if isempty(mi_info); continue; end
        [mi_max, mi_node, mi_time] = mutual_info_max(mi_info, C, 1);
        if isempty(mi_max); continue; end
        mi_mean(n,c,g,b) = mean(mi_max);
        mi_top(n,c,g,b) = max(mi_max);
        mi_min(n,c,g,b) = min(mi_max);
        mi_std(n,c,g,b) = std(mi_max);
        mi_time(n,c,g,b) = mean(mi_time);
        disp('saving...')
        save(['avalanche/sweep_results/' r])
    end
end; end; end; end

clear iter i
