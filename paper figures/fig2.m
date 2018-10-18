%%
load('/Users/harangju/Developer/avalanche/paper figures/fig1_1.mat')
%% stochastic fraction alive
dur = 100;
trials = 1e3;
n = 8;
[pats, probs] = pings_single(p.N);
Y = avl_smp_many({pats{n}},1,A,dur,trials);
f = avl_fraction_alive(Y);
%% predicted fraction alive
S = states(p.N);
T = p_transition(A,S); % state transition matrix
p1 = p_state(pats{n},S); % initial state probability vector
P = p_states(p1,T,dur); % calculate state probabilities for dur
fp = 1 - P(1,1:length(f)); % predicted fraction alive
%% plot
plot([f;fp]')
prettify
