%% 2-3 dominant eigenvalue analysis
iter = 100;
dur = 100;
trials = 1e5;
N = 10;
As = cell(1,iter);
Ys = cell(1,iter);
rng(1)
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




%% durations - slopes
durs = cell(1,length(As));
xs = cell(1,length(As));
ys = cell(1,length(As));
for i = 1 : length(xs)
    durs{i} = avl_durations_cell(Ys{i});
    [xs{i}, ys{i}] = hist_log10(durs{i}, dur);
end

%% calculate - slope, intercepts of dur distr
fits = zeros(length(xs),2);
pts = cell(1,length(xs));
for i = 1 : length(As)
    pts{i} = ceil(length(xs{i})/5) : length(xs{i})-1;
    fits(i,:) = polyfit(xs{i}(pts{i}), ys{i}(pts{i}), 1);
end
clear i f

%% plot
figure(2); clf; hold on
scatter(ev_dom,fits(:,1),'.')
f = polyfit(ev_dom',fits(:,1),1);
x = min(ev_dom) : 0.01 : max(ev_dom);
plot(x,polyval(f,x),'r')
hold off; prettify
figure(3); clf; hold on
scatter(ev_sum,fits(:,1),'.')
f_sum = polyfit(ev_sum',fits(:,1),1);
x = min(ev_sum) : 0.01 : max(ev_sum);
plot(x,polyval(f_sum,x),'r')
hold off; prettify
disp(corr(ev_sum',fits(:,1)))
