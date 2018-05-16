
%% generate network
param = default_network_parameters;
param.num_nodes = 100;
param.num_nodes_input = param.num_nodes;
param.num_nodes_output = param.num_nodes;
param.frac_conn = 0.4;
param.graph_type = 'WRG';
param.exp_branching = 1;
[A, B, C] = network_create(param);
A = scale_weights_to_criticality(A);
%% view network
colormap(flipud(gray))
subplot(2,1,1)
imagesc(A)
prettify; colorbar
subplot(2,1,2)
g = graph_from_matrix(A);
plot(g)
prettify
%% generate spontaneous avalanches
p_spike = 1e-5;
iter = 1e6;
tic
Y = spontaneous_avalanches(A,B,p_spike,1e5);
toc
%% view spikes
clf
imagesc(Y)
colorbar; prettify; xlabel('time bins'); ylabel('neurons')
%% find avalanches
aval = find_avalanches(Y);
%% power law - duration
subplot(2,1,1)
aval_durs = cellfun(@size,aval,...
    num2cell(2*ones(1,length(aval))));
[n,edges] = histcounts(aval _durs);
% scatter(log10(edges(1:end-1)),log10(n)/length(aval),'filled')
plot(log10(edges(1:end-1)),log10(n)/length(aval),'-*')
% plot(edges(1:end-1),n,'-*')
prettify; xlabel('avalanche duration log_{10}'); ylabel('avalanches')
%% power law - size
subplot(2,1,2)
size_aval = @(a) sum(sum(a,2)>0);
aval_sizes = cellfun(size_aval,aval);
[n,edges] = histcounts(aval_sizes);
% scatter(log10(edges(1:end-1)),log10(n)/length(aval),'filled')
plot(log10(edges(1:end-1)),log10(n)/length(aval),'-*')
% plot(edges(1:end-1),n,'-*')
prettify; xlabel('avalanche size log_{10}'); ylabel('avalanches')

