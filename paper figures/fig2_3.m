%% 2-3 dominant eigenvalue analysis
iter = 100;
dur = 1e4;
trials = 1e4;
N = 10;
As = cell(1,iter);
Ys = cell(1,iter);
for i = 1 : iter
    disp(i)
    p = default_network_parameters;
    p.N = N; p.N_in = N;
    p.frac_conn = 0.2;
    p.graph_type = 'weightedrandom';
    p.weighting = 'uniform'; p.weighting_params = 1;
    p.critical_branching = false;
    p.critical_convergence = true;
    As{i} = network_create(p);
    pats = pings_single(p.N);
    Ys{i} = avl_smp_many(pats,ones(1,N)/N,As{i},dur,trials);
end

%% eigenvalues
ev_dom = zeros(1,iter);
ev_sum = zeros(1,iter);
for i = 1 : iter
    ev_dom(i) = eig_dom(As{i}');
    ev_sum(i) = eig_sum(As{i}');
end

%% durations
durs = cell(1,iter);
dm = zeros(1,iter);
for i = 1 : iter
    durs{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(durs{i});
end; clear i

%% plot
figure(2); clf; hold on
scatter(ev_dom,dm,'.')
scatter(ev_sum,dm,'.')
% f = fit(eigvals',dm',fittype('a*exp(b*x)+c'));
f = polyfit(eigvals',dm',1);
x = min(eigvals) : 0.01 : max(eigvals);
% plot(f,eigvals',dm')
plot(x,polyval(f,x),'r')
prettify

%% linear regression
lr = polyfit(eigvals',log10(dm'),1);
c = corr(eigvals',log10(dm'));

%% eigen projections

