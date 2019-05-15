%% acyclic 3-node graph 
Aa = [0 .5 0; 0 0 .5; 0 0 0];
%% cyclic 3-node graph
Ac = [0 .5 0; 0 0 .5; 0.5 0 0];
%% simulation
[pats,probs] = pings_single(3);
T = 1e4; K = 1e6;
[Ya,pata] = avl_smp_many(pats,probs,Aa,T,K);
[Yc,patc] = avl_smp_many(pats,probs,Ac,T,K);
%%
dur_a = avl_durations_cell(Ya);
dur_c = avl_durations_cell(Yc);
%%
colors = linspecer(2);
%%
figure
x = unique(dur_a);
y = histcounts(dur_a,[x max(x)+1]);
loglog(x,y/sum(y),'s','Color',colors(1,:),'MarkerSize',7)
hold on
x = unique(dur_c);
y = histcounts(dur_c,[x max(x)+1]);
loglog(x,y/sum(y),'.','Color',colors(2,:),'MarkerSize',10)
prettify
xlim([10^0 10^2])
legend({'acyclic','cyclic'})
