
%% network
rng(1)
p = default_network_parameters;
p.N = 100;
p.frac_conn = 0.2;
p.graph_type = 'weightedrandom';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
A = network_create(p);
figure(3); imagesc(A); prettify; colorbar
%% stimulus
num_pat = 20; T = 1e2; K = 1e3;
stim_mag = 4;
pats = cell(1,num_pat);
for i = 1 : length(pats)
    pats{i} = zeros(p.N,1);
    pats{i}(randperm(p.N,stim_mag)) = 1;
end; clear i
patsm = cell2mat(pats);
%% controllability
stim_ac = finite_impulse_responses_input(A',patsm,10);
mc = control_modal(A');
stim_mc = sum(patsm .* mc,1);
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
surf(1:10, stim_ac(order_stim_ac), distm(1:10,order_stim_ac)')
prettify; axis vis3d; view([45 15])
%% stochastic
Ys = cell(1,length(pats));
orders = zeros(length(pats),K);
probs = zeros(length(pats));
disp('Simulating cascades...')
disp(repmat('#',[1 length(pats)]))
for i = 1 : length(pats)
    fprintf('.')
    probs(i,:) = 0.5*ones(1,length(pats)) / (length(pats)-1);
    probs(i,i) = 0.5;
    [Ys{i}, orders(i,:)] = avl_smp_many(pats,probs(i,:),A,T,K);
end; clear i; fprintf('\n')
%% durations
dur = cell(1,length(pats));
dm = zeros(1,length(pats));
for i = 1 : length(pats)
    dur{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(dur{i});
end; clear i
%% duration correlations
[c(1),pval(1)] = corr(stim_ac,dm');
[c(2),pval(2)] = corr(stim_mc',dm');
fprintf('\tAC\tMC\nCorr:\t%.4f\t%.4f\t\np-val:\t%.2g\t%.2g\t\n',...
    c(1),c(2),pval(1),pval(2));
%% plot durations
figure(4); clf; hold on
for i = 1 : 20 : length(pats)
    [x,y] = hist_log10(dur{i},K/10);
    scatter(x,y,'.')
end; clear i x y; hold off; prettify
%% mutual information
mi = zeros(length(pats),T);
disp('Calculating mutual information...')
disp(repmat('#',[1 length(pats)]))
for i = 1 : length(pats)
    fprintf('.')
    pat = orders(i,:)';
    pat(orders(i,:)==i) = 1; pat(orders(i,:)~=i) = 0;
    mi(i,:) = mutual_info_pop(avl_cell_to_mat(Ys{i}),pat);
end; clear i pat; fprintf('\n')
%% plot controllability & mutual information
figure(2); clf
surf(1:10,stim_ac(order_stim_ac),mi(order_stim_ac,1:10),'LineWidth',0.1);
% imagesc(mi(idx,:));
prettify; axis vis3d; view([5 2])



