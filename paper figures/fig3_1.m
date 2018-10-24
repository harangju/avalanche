
%% acyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0 0 0];

%% cyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0.5 0 0];

%% simulation
[pats,probs] = pings_single(3);
dur = 1e3; iter = 1e5;
tic
[Y,pat] = avl_smp_many(pats,probs,A,dur,iter);
toc; beep
%%
durations = avl_durations_cell(Y);
%%
[c_d,e_d,bin_idx] = histcounts(durations);
x = log10(e_d(2:end));
y = log10(c_d/sum(c_d));
x(isinf(y)) = [];
y(isinf(y)) = [];
f = polyfit(x,y,1);
disp(f)
%%
colors = linspecer(2);
%%
scatter(x,y,10,[3.1, 18.8, 42]./100,'filled')
prettify
%%
legend({'acyclic','cyclic'})
