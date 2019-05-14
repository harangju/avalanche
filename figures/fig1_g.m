%% source
% uncomment to use same data from paper, Ju et al. 2019
basedir = '~/Downloads/Source Data';
%% g
ns = 50 : 50 : 300;
dur = 15;
trials = 1e4;
Ys = cell(1,length(ns));
orders = cell(1,length(ns));
Xs = cell(1,length(ns));
for i = 1 : length(ns)
    n = ns(i);
    disp(n)
    p = default_network_parameters;
    p.N = 10; p.N_in = 10;
    p.frac_conn = 0.2;
    p.graph_type = 'weightedrandom';
    p.weighting = 'uniform'; p.weighting_params = 1;
    p.critical_branching = false;
    p.critical_convergence = true;
    [A, B] = network_create(p);
    [pats, probs] = pings_single(p.N);
    [Ys{i},orders{i}] = avl_smp_many(pats,probs,A,dur,trials);
    Xs{i} = avl_linear_many(pats,A,dur);
end; clear i n A B pats probs
%%
df = cell(1,length(ns));
for i = 1 : length(ns)
    df{i} = 0;
    for n = 1 : p.N
        Y_n = avl_cell_to_mat(Ys{i}(orders{i}==n));
        Y_n_avg = mean(Y_n,3);
        df{i} = [df{i}; Y_n_avg(Y_n_avg>0) - Xs{i}{n}(Y_n_avg>0)];
    end
end; clear i n Y_n Y_n_avg
%% plot diffs
df_m = cellfun(@mean,df)
df_se = cellfun(@std,df);% ./ sqrt(cellfun(@length,df));
errorbar(ns, df_m, df_se, 'ks')
prettify
% axis([0 max(ns) -0.0005 0.0005])
axis([0 max(ns) -0.03 0.03])


