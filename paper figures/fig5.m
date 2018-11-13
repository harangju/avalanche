
%% network
p = default_network_parameters;
p.N = 100;
p.N_in = p.N; p.N_out = p.N;
p.frac_conn = 0.2;
p.graph_type = 'weightedrandom';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
A = network_create(p);
%% stimulus
pats = pings_single(p.N);
patsm = cell2mat(pats);
T = 30;
K = 1e3;
%% simulation
Ys = cell(1,length(pats));
orders = zeros(length(pats),K);
for i = 1 : length(pats)
    disp(i)
    probs = 0.5*ones(1,length(pats)) / (length(pats)-1);
    probs(i) = 0.5;
    [Ys{i}, orders(i,:)] = avl_smp_many(pats,probs,A,T,K);
end; clear i probs; disp('done')
%% mutual information
mi = zeros(length(pats),T);
for i = 1 : length(pats)
    pat = orders(i,:)';
    pat(orders(i,:)==i) = 1; pat(orders(i,:)~=i) = 2;
    mi(i,:) = mutual_info_pop(avl_cell_to_mat(Ys{i}),pat);
end; clear i pat
%% controllability
ac = ;

%% 3.a mutual information - simulation
dur = 30; iter = 1e3;
mi_pops = zeros(length(pats), dur);
for i = 1 : length(pats)
    probs = 0.5*ones(1,length(pats)) / (length(pats)-1);
    probs(i) = 0.5;
    disp([num2str(i) '/' num2str(length(pats))])
    tic
    [Y_mi,pat_mi] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
    toc
    pa = pat_mi'; pa(pat_mi==1) = 1; pa(pat_mi~=i) = 2;
    mi_pops(i,:) = mutual_info_pop(Y_mi,pa);
end; clear i pa

%% 3.b mutual information - plot
figure(4)
clf; colormap parula
[d_real_sort,idx] = sort(d_real,'descend');
range = [1:2 4:length(d_real_sort)];
surf(0:dur-1, d_real_sort(range),...
    mi_pops(idx(range),:), 'LineWidth', 0.1);
% surf(0:dur-1, d_real_sort,...
%     mi_pops(idx,:), 'LineWidth', 0.1);
prettify; axis([0 dur 0 1 0 1]); axis vis3d
set(gca,'FontSize',14);
