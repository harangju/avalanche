
%% acyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0 0 0];

%% cyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0.5 0 0];

%% simulation
[pats,probs] = pings_single(3);
dur = 1e4; iter = 1e4;
tic
[Y,pat] = avl_smp_many(pats,probs,A,dur,iter);
toc; beep
%%
durations = avl_durations_cell(Y);
[alpha, xmin] = plfit(durations);
plplot(durations,xmin,alpha)
%%
colors = linspecer(2);
%%
scatter(x,y,10,[3.1, 18.8, 42]./100,'filled')
prettify
%%
legend({'acyclic','cyclic'})
