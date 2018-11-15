
%% network
rng(1)
p = default_network_parameters;
p.N = 100;
p.frac_conn = 0.2;
p.graph_type = 'mod4comm';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
A = network_create(p);
figure(3); imagesc(A); prettify; colorbar
%% stimulus
T = 1e2; K = 1e3;
stim_mag = 4;
% pats = cell(1,num_pat);
ac = finite_impulse_responses(A',10);
[~,order_ac] = sort(ac);
pats = cell(1,p.N/stim_mag);
for i = 1 : length(pats)
    pats{i} = zeros(p.N,1);
    pats{i}(order_ac(1+stim_mag*(i-1) : stim_mag*i)) = 1;
%     pats{i}(randperm(p.N,stim_mag)) = 1;
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
%% mutual information
mi = zeros(length(pats),T);
disp('Calculating mutual information...')
disp(repmat('#',[1 length(pats)]))
for i = 1 : length(pats)
    fprintf('.')
    pat = orders(i,:)';
    pat(orders(i,:)==i) = 1; pat(orders(i,:)~=i) = 0;
    m = mutual_info_pop(avl_cell_to_mat(Ys{i}),pat);
    mi(i,1:length(m)) = m;
end; clear i pat m; fprintf('\n')
%% plot distance
figure(1); clf
surf(1:10, stim_ac(order_stim_ac), distm(1:10,order_stim_ac)')
prettify; axis vis3d; view([45 15])
%% plot durations
figure(4); clf; hold on
for i = 1 : 20 : length(pats)
    [x,y] = hist_log10(dur{i},K/10);
    scatter(x,y,'.')
end; clear i x y; hold off; prettify
%% plot controllability & mutual information
figure(2); clf
% surf(1:20,stim_ac(order_stim_ac),mi(order_stim_ac,1:20),'LineWidth',0.1);
[~,order_dm] = sort(dm);
surf(1:20,dm(order_dm),mi(order_dm,1:20))
prettify; axis vis3d; view([45 15])
%% calculate slopes of mi
t_range = 1:20;
fits_mi = zeros(length(pats),2);
for i = 1 : length(pats)
    fits_mi(i,:) = polyfit(t_range,mi(i,t_range),1);
end; clear i
%% plot against mean duration
figure(3); clf; hold on
scatter(dm,fits_mi(:,1),32,[3.1, 18.8, 42]./100,'.')
x = min(dm) : 1e-2 : max(dm);
fit_decay_mi = polyfit(dm',fits_mi(:,1),1);
plot(x,polyval(fit_decay_mi,x),'r')
hold off; prettify
%% calculate slopes of distance
t_range = 1 : 10;
fits_dist = zeros(length(pats),2);
for i = 1 : length(pats)
    fits_dist(i,:) = polyfit(t_range,distm(t_range,i)',1);
end; clear i
%% plot against fir
figure(4); clf; hold on
scatter(stim_ac,fits_dist(:,1),32,[3.1, 18.8, 42]./100,'.')
x = min(stim_ac) : 1e-2 : max(stim_ac);
fit_decay_dist = polyfit(stim_ac,fits_dist(:,1),1);
plot(x,polyval(fit_decay_dist,x),'r')
hold off; prettify
%% correlations
[c(1),pval(1)] = corr(stim_ac,dm');
[c(2),pval(2)] = corr(stim_mc',dm');
[c_decay_mi,pval_decay_mi] = corr(dm',fits_mi(:,1));
[c_decay_dist,pval_decay_dist] = corr(dm',fits_dist(:,1));
fprintf(['\tAC\tMC\tMI\tDIST\n'...
    'Corr: \t%.4f\t%.4f\t%.4f\t%.4f\n'...
    'p-val:\t%.2g\t%.2g\t%.2g\t%.2g\n'],...
    c(1),c(2),c_decay_mi,c_decay_dist,...
    pval(1),pval(2),pval_decay_mi,pval_decay_dist);

