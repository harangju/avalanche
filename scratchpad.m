% scratchpad.m
% Written by Harang Ju. January 29, 2018.

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.num_nodes = 32;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 1e-1;
p.graph_type = 'WRG';
% p.exp_branching = .6;
p.exp_branching = 1;
% p.weighting = 'F';
[A, B, C] = network_create(p);
disp('Done initializing.')

%% mutual information - single nodes
iter = 1e3; dur = 7;
[Y, pat] = ping_nodes(A, B, iter, dur);
mi_info = mutual_info(Y,pat);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);
%% mutual information - delayed pairs
iter = 3e4; dur = 5;
[Y, pat] = ping_delayed_pairs(A, B, iter, dur);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);

%% avalanche intersections


%%
subplot(2,2,1)
scatter(mi_max(:,1),indegree(A),'filled')
axis square; prettify
xlabel('max-I output node'); ylabel('indegree')
subplot(2,2,2)
scatter(mi_info(:,1),branching(A),'filled');
axis([0 0.2 0 2]); axis square; prettify
xlabel('I(X;Y)'); ylabel('\sigma')
subplot(2,2,3)
% scatter(mi_info(:,1),sum(A(:,mi_info(:,2)),2),'filled');
axis([0 0.2 0 2]); axis square; prettify
xlabel('I(X;Y)'); ylabel('weight')
subplot(2,2,4)
scatter(mi_info(:,1),mean_sizes,'filled')
axis([0 0.2 0 10]); axis square; prettify
xlabel('I(X;Y)'); ylabel('avalanche size')

