% scratchpad.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Initialize
disp('Initializing...')
p = default_network_parameters;
p.num_nodes = 30;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 3e-1;
p.graph_type = 'WRG';
p.exp_branching = 1;
[A, B, C] = network_create(p);

%% Analysis
disp('Analyzing...')
sig = branching(A);
disp(['avg branching parameter: ' num2str(mean(sig)) '+-' ...
    num2str(std(sig)/p.num_nodes)])
u_t = zeros(p.num_nodes, 1);
u_t(find(B,1), 1) = 1;
Y_t = trigger_avalanche(A, B, u_t, 10);
clf; plot_summary(A, avalanche_size_analytical(A, B, 5),...
    ave_control(A), modal_control(A), Y_t, avalanche_transitions(Y_t, A))

%% Mutual information

probs = [0.5 0.5];
iter = 1e2; dur = 5;
max_mi = cell(1,p.num_nodes_input);
max_nodes = cell(1,p.num_nodes_input);
max_time = cell(1,p.num_nodes_input);
mean_sizes = zeros(1,p.num_nodes_input);
input_nodes = find(B);
for i = 2:length(input_nodes)-1
    disp(i)
%     pattern = {{input_nodes(i)}, {}};
    pattern = {{input_nodes(i) input_nodes(i-1)},...
        {input_nodes(i) input_nodes(i+1)}};
    [Y, pat, s] = trigger_many_avalanches(A, B, pattern, probs, dur, iter);
    mean_sizes(i) = mean(s);
    info = mutual_info(Y, pat);
    [max_mi{i}, max_nodes{i}, max_time{i}] = mutual_info_max(info, C,...
        max(cellfun(@length,pattern)));
end
max_info = zeros(p.num_nodes_input,3);
for i = 1:length(input_nodes)
    [~,idx] = max(max_mi{i});
    if isempty(idx); continue; end
    max_info(i,:) = [max_mi{i}(idx) max_nodes{i}(idx) max_time{i}(idx)];
end
clear probs iter dur input_nodes i pattern Y pat s info idx
% shuffle input output nodes
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

