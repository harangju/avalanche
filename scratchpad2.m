
%%
N = 100;
A = diag(rand(1,N)*0.9);
B = ones(N,1);
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
exp_dur = zeros(1,N);
for i = 1 : N
exp_dur(i) = find(lin(:,i)<thresh,1);
end
scatter(d,exp_dur,'g')
prettify; hold off
%%
[d'; dur_mean; exp_dur; d'.^dur_mean]

%%
t = 40;
clf; hold on
plot(d.^(0:t)','LineWidth',1.5)
plot(1:t,thresh*ones(1,t),'LineWidth',1.5)
hold off 
prettify

%%
scatter(d,d'.^dur_mean,'filled')
prettify
axis([0 1 0 0.06])
