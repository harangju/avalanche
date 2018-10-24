%% simulate graph types
% ns = 50 : 50 : 300;
graph_types = {'weightedrandom','ringlattice','mod4comm','wattsstrogatz'};
iter = 30;
dur = 100;
N = 12;
trials = 1e4;
Ys = cell(length(graph_types),iter,N);
As = cell(length(graph_types),iter);
for i = 1 : length(graph_types)
    disp(graph_types{i})
    for j = 1 : iter
        disp(['iteration: ' num2str(j)])
        p = default_network_parameters;
        p.N = N; p.N_in = N;
        p.frac_conn = 0.2;
        p.graph_type = graph_types{i};
        p.weighting = 'uniform'; p.weighting_params = 1;
        p.critical_branching = false;
        p.critical_convergence = true;
        As{i,j} = network_create(p);
        pats = pings_single(p.N);
        for k = 1 : N
            Ys{i,j,k} = avl_smp_many({pats{k}},1,As{i,j},dur,trials);
        end
    end
end; clear i n A B pats probs
%% 
S = states(N);
pats = pings_single(N);
fs = cell(length(graph_types),iter,N);
fps = cell(length(graph_types),iter,N);
rmses = zeros(length(graph_types),iter,N);
for i = 1 : length(graph_types)
    disp(graph_types{i})
    for j = 1 : iter
        disp(['iteration: ' num2str(j)])
        T = p_transition(As{i,j},S);
        for k = 1 
            fs{i,j,k} = avl_fraction_alive(Ys{i,j,k});
            p1 = p_state(pats{k},S);
            P = p_states(p1,T,dur);
            fps{i,j,k} = 1 - P(1,1:length(fs{i,j,k}));
            rmses(i,j,k) = sqrt(mean((fs{i,j,k} - fps{i,j,k}).^2));
        end
    end
end
%% plot
% figure(1)
% boxplot(reshape(rmses, [length(graph_types), iter*N])')
% prettify
mean(reshape(rmses, [4,30*12]),2)'
max(reshape(rmses, [4,30*12])')

%% 2-3 dominant eigenvalue analysis
iter = 100;
dur = 100;
trials = 1e5;
N = 10;
As = cell(1,iter);
Ys = cell(1,iter);
for i = 1 : iter
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
eigvals = zeros(1,iter);
for i = 1 : iter
    [~,d] = eig(As{i}');
    dm = diag(d);
    eigvals(i) = max(real(dm));
    if -1*min(real(dm)) > eigvals(i)
        eigvals(i) = -1*min(real(dm));
    end
end; clear i d dm

%% durations
durs = cell(1,iter);
dm = zeros(1,iter);
for i = 1 : iter
    durs{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(durs{i});
end; clear i

%% plot
figure(2); clf
scatter(eigvals,dm,'.')
hold on
f = fit(eigvals',dm',fittype('a*exp(b*x)+c'));
x = min(eigvals) : 0.01 : max(eigvals);
plot(f,eigvals',dm')
prettify

%% linear regression
lr = polyfit(eigvals',log10(dm'),1);
c = corr(eigvals',log10(dm'));

%% eigen projections

