
%% load network
load('beggs data/DataSet2.mat')
A = estimate_network_from_spikes(data, 0.1);
A = scale_weights_to_criticality(A);
B = ones(size(A,1),1);
C = B;

%% present patterns
iter = 1e3; dur = 7;
[Y, pat] = ping_nodes(A, B, iter, dur); beep

%% calculate mutual information
mi_info = mutual_info(Y,pat,C);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);
nodes = find(max(mi_info,[],2)>0);

%% branching, outdegree vs mutual info
subplot(1,2,1)
scatter(branching(A(nodes,:)),mi_max,'filled')
prettify; axis square; xlabel('\sigma'); ylabel('I(X;Y)')
subplot(1,2,2)
scatter(outdegree(A(nodes,:)),mi_max,'filled')
prettify; axis square; xlabel('outdegree'); ylabel('I(X;Y)')

%% convergence, indegree vs mutual info
subplot(1,2,1)
scatter(convergence(A(:,nodes)),mi_max,'filled')
prettify; axis square; xlabel('convergence'); ylabel('I(X;Y)')
p = polyfit(convergence(A(:,nodes)),mi_max,1);
hold on; plot(0:0.1:6,p(1)*(0:0.1:6)+p(2),'LineWidth',2); hold off
subplot(1,2,2)
scatter(indegree(A(:,nodes)),mi_max,'filled')
prettify; axis square; xlabel('indegree'); ylabel('I(X;Y)')
p = polyfit(indegree(A(:,nodes)),mi_max,1);
hold on; plot(0:0.1:14,p(1)*(0:0.1:14)+p(2),'LineWidth',2); hold off

%% controllability
scatter(ave_control(A(nodes,nodes)),mi_max,'filled')
prettify; axis square; xlabel('average controllability'); ylabel('I(X;Y)')


%% centrality - betwenness vs mutual info
g = graph_from_matrix(A);
c = centrality(g,'betweenness');
scatter(c(nodes),mi_max,'filled')

%% rich-club
k = 5;
rc = rich_club_coeff(A,k)

%% avalanche size


