
%% network
rng(1)
p = default_network_parameters;
p.N = 100;
p.frac_conn = 0.2;
p.graph_type = 'weightedrandom';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
A = network_create(p);
figure(3)
imagesc(A); prettify; colorbar
%% stimulus
pats = pings_single(p.N);
stim_mag = 1;
pats = cell(1,p.N);
for i = 1 : p.N
    pats{i} = zeros(p.N,1);
    pats{i}(randperm(p.N,stim_mag)) = 1;
end; clear i
patsm = cell2mat(pats);
T = 1e3;
K = 1e3;
%% controllability
ac = finite_impulse_responses(A',10);
stim_ac = sum(patsm .* ac);
[~,order_stim_ac] = sort(stim_ac);
%% linear
Xs = avl_linear_many(pats,A,T);
%% distance
dist = zeros(T, length(pats), length(pats)-1);
for i = 1 : length(pats)
    for j = [1:i-1 i+1:length(pats)]
        dist(:,i,j) = sqrt(sum((Xs{i}-Xs{j}).^2, 1));
    end
end; clear i j
distm = mean(dist,3);
dists = std(dist,0,3);
%% plot distance
figure(1); clf
surf(1:T, stim_ac(order_stim_ac), distm(:,order_stim_ac)')
prettify; axis vis3d
%% stochastic
Ys = cell(1,length(pats));
orders = zeros(length(pats),K);
for i = 1 : length(pats)
    disp(i)
    probs = 0.5*ones(1,length(pats)) / (length(pats)-1);
    probs(i) = 0.5;
    [Ys{i}, orders(i,:)] = avl_smp_many(pats,probs,A,T,K);
end; clear i probs; disp('done')
%% durations
dur = cell(1,length(pats));
dm = zeros(1,length(pats));
for i = 1 : length(pats)
    dur{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(dur{i});
end; clear i
%% mutual information
mi = zeros(length(pats),T);
for i = 1 : length(pats)
    pat = orders(i,:)';
    pat(orders(i,:)==i) = 1; pat(orders(i,:)~=i) = 0;
    mi(i,:) = mutual_info_pop(avl_cell_to_mat(Ys{i}),pat);
end; clear i pat
%% plot controllability & mutual information
figure(2); clf
surf(1:T, stim_ac(order_stim_ac), mi(order_stim_ac,:), 'LineWidth', 0.1);
% imagesc(mi(idx,:));
prettify; axis vis3d


