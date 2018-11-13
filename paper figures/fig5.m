
%% network
p = default_network_parameters;
p.N = 100;
p.N_in = p.N; p.N_out = p.N;
p.frac_conn = 0.2;
p.graph_type = 'randomgeometric';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
A = network_create(p);
%% stimulus
pats = pings_single(p.N);
stim_mag = 10;
pats = cell(1,p.N);
for i = 1 : p.N
    pats{i} = zeros(p.N,1);
    pats{i}(randperm(p.N,stim_mag)) = 1;
end; clear i
patsm = cell2mat(pats);
%% simulation
T = 30;
K = 1e3;
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
    pat(orders(i,:)==i) = 1; pat(orders(i,:)~=i) = 0;
    mi(i,:) = mutual_info_pop(avl_cell_to_mat(Ys{i}),pat);
end; clear i pat
%% controllability
ac = finite_impulse_responses(A',10);
stim_ac = sum(patsm .* ac);
%% plot controllability & mutual information
clf
[~,idx] = sort(stim_ac);
% surf(1:T, stim_ac(idx), mi(idx,:), 'LineWidth', 0.1);
imagesc(mi(idx,:));
prettify; axis vis3d
