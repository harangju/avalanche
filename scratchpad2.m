
%%
N = 10;
A = diag(rand(1,10));
B = ones(10,1);
p.num_nodes = N;
imagesc(A); colorbar; prettify
%%
g = graph_from_matrix(A);
plot(g)

%% fig2.m

%%
thresh = 0.05;
clf; hold on
scatter(d(pat),duration,'.')
scatter(d,dur_mean,'filled','r')
lin = d.^(1:100)';
exp_dur = zeros(1,10);
for i = 1 : 10
exp_dur(i) = find(lin(:,i)<thresh,1);
end
scatter(d,exp_dur,'g')
prettify; hold off
[d'; dur_mean; exp_dur]

%%
t = 30;
clf; hold on
plot(d.^(0:t)','LineWidth',1.5)
plot(1:t,thresh*ones(1,t),'LineWidth',1.5)
hold off 
prettify

%%
[d'; dur_mean; exp_dur; sqrt(d'./(1-d').^2); 1./(1-d')]
