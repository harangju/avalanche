%% diffs for # nodes
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
    [Ys{i},orders{i}] = avalanche_smp_many(pats,probs,A,dur,trials);
    Xs{i} = avalanche_linear_many(inputs,A,dur);
end
%%
df = cell(1,length(ns));
for i = 1 : length(ns)
    
%     df{i} = a_emp_t{i}(a_ana_t{i}>0) - a_ana_t{i}(a_ana_t{i}>0);
    df{i} = a_ana_t{i}(a_ana_t{i}>0) - a_emp_t{i}(a_ana_t{i}>0);
end
%% plot diffs
df_m = cellfun(@mean,df)
df_se = cellfun(@std,df);% ./ sqrt(cellfun(@length,df));
errorbar(ns, df_m, df_se, 'ks')
prettify
% axis([0 max(ns) -0.0005 0.0005])
axis([0 max(ns) -0.02 0.02])


