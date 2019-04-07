%%
load('/Users/harangju/Developer/avalanche paper data/fig1_1.mat')
%% stochastic fraction alive
dur = 100;
trials = 1e6;
n = 8;
[pats, probs] = pings_single(p.N);
Y = avl_smp_many({pats{n}},1,A',dur,trials);
f = avl_fraction_alive(Y);
d = avl_durations_cell(Y);
%% predicted fraction alive
S = states(p.N);
T = p_transition(A,S); % state transition matrix
p1 = p_state(pats{n},S); % initial state probability vector
P = p_states(p1,T,dur); % calculate state probabilities for dur
fp = 1 - P(1,1:max(d)); % predicted fraction alive
%% plot - network
color1 = [3.1, 18.8, 42]/100;
figure(1)
imagesc(A')
prettify
colorbar
% colormap([linspace(1,color1(1),100)' linspace(1,color1(2),100)'...
%     linspace(1,color1(3),100)'])
colormap(flipud(gray))
set(gca,'LineWidth',1.8)
%% plot - state-space prediction
color2 = [2 43.9 69]/100;
figure(2)
clf
loglog(f,'.','Color',color1,'MarkerSize',10)
hold on
loglog(fp,'r')
% legend({'stochastic model','state-space prediction'})
prettify
%% rmse
rmse = sqrt(mean((f - fp).^2));
%% plot - 
