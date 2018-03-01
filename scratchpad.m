% scratchpad.m
% Written by Harang Ju. January 29, 2018.

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.num_nodes = 16;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 2e-1;
p.graph_type = 'WRG';
% p.exp_branching = .6;
p.exp_branching = 1;
% p.weighting = 'F';
[A, B, C] = network_create(p);

%% mutual information - single nodes
iter = 1e2; dur = 5; input_nodes = find(B);
patterns = cell(1,p.num_nodes_input);
for i = 1 : p.num_nodes_input
%     patterns{i} = {{input_nodes(i)}, {}};
    patterns{i} = {input_nodes(i)};
end
% summary_ping = mutual_info_max_patterns(A, B, C, patterns, dur, iter);
[Y, pat] = trigger_many_avalanches(A,B,patterns,...
    ones(1,p.num_nodes_input)/p.num_nodes_input,5,1e3);
mi_info = mutual_info(Y,pat);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);
clear i j iter dur input_nodes
% clear Y pat
%% mutual information - delayed pairs
iter = 1e2; dur = 5; input_nodes = find(B);
patterns = cell(1,p.num_nodes_input^2);
for i = 1 : p.num_nodes_input
    for j = 1 : p.num_nodes_input
        patterns{(i-1)*p.num_nodes_input+j} = ...
            {{input_nodes(i) input_nodes(j)},...
            {input_nodes(i) input_nodes(i)}};
%         patterns{(i-1)*p.num_nodes_input+j} = ...
%             {input_nodes(i), input_nodes(j)};
    end
end
summary_delayed_pairs = ...
    mutual_info_max_patterns(A, B, C, patterns, dur, iter);
clear i j iter dur input_nodes

%% avalanche intersections


%%
subplot(2,2,1)
scatter(max_info(:,2),indegree(A),'filled')
axis([0 100 0 20]); axis square; prettify
xlabel('max-I output node'); ylabel('indegree')
subplot(2,2,2)
scatter(max_info(:,1),branching(A),'filled');
axis([0 0.2 0 2]); axis square; prettify
xlabel('I(X;Y)'); ylabel('\sigma')
subplot(2,2,3)
scatter(max_info(:,1),sum(A(:,max_info(:,2)),2),'filled');
axis([0 0.2 0 2]); axis square; prettify
xlabel('I(X;Y)'); ylabel('weight')
subplot(2,2,4)
scatter(max_info(:,1),mean_sizes,'filled')
axis([0 0.2 0 10]); axis square; prettify
xlabel('I(X;Y)'); ylabel('avalanche size')

