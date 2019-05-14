%% 2-3 dominant eigenvalue analysis
rng(1)
iter = 100;
dur = 100;
trials = 1e5;
p = default_network_parameters;
p.N = 10;
p.frac_conn = 0.2;
p.graph_type = 'ringlattice';
p.weighting = 'uniform';
p.weighting_params = 1;
pats = pings_single(p.N);
%% 
disp('Simulate cascades...')
disp(repmat('#',[1 iter]))
As = cell(1,iter);
Ys = cell(1,iter);
for i = 1 : iter
    fprintf('.')
    As{i} = network_create(p);
    Ys{i} = avl_smp_many(pats,ones(1,p.N)/p.N,As{i},dur,trials);
end; fprintf('\n')

%% eigenvaluesp
ev_dom = zeros(1,iter);
ev_sum = zeros(1,iter);
for i = 1 : iter
    ev_dom(i) = eig_dom(As{i}');
    ev_sum(i) = eig_sum(As{i}');
end

%% mean durations
durs = cell(1,iter);
dm = zeros(1,iter);
for i = 1 : iter
    durs{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(durs{i});
end; clear i

%% dominant eigenvalue
figure(1); clf; hold on
scatter(ev_dom,dm,'.')
f_dom = fit(ev_dom',dm',fittype('a*exp(b*x)+c'));
plot(f_dom,ev_dom',dm')
hold off; prettify
[c_dom,pval_dom] = corr(ev_dom',log10(dm'));
disp([c_dom pval_dom])

%% sum of eigenvalues
figure(2); clf; hold on
scatter(ev_sum,dm,'.')
f_sum = fit(ev_sum',dm',fittype('a*exp(b*x)+c'));
plot(f_sum,ev_sum',dm')
hold off; prettify
[c_sum,pval_sum] = corr(ev_sum',log10(dm'));
disp([c_sum pval_sum])

