%%
load('/Users/harangju/Developer/avalanche/paper figures/fig1_1.mat')
%%
dur = 1e3;
trials = 1e5;
n = 8;
[pats, probs] = pings_single(p.N);
Y = avalanche_smp_many(pats{n},1,A,dur,trials);
d = avl_durations_cell(Y);
f = avl_fraction_alive();
%%

