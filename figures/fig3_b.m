
%%
N = 10;
A0 = triu(ones(N)) - eye(N);
A0 = A0 .* 0.2;
%% rewire probabilities
ps = 0 : 0.1 : 1;
trials = 10;
durs = cell(length(ps),trials);
As = cell(length(ps),trials);
Ys = cell(length(ps),trials);
i_y0s = cell(length(ps),trials);
%%
Tmax = 1e4; K = 1e4;
[y0s,p_y0s] = pings_single(N);
for i = 1 : length(ps)
    for j = 1 : trials
        disp(num2str([i j]))
        As{i,j} = network_rewire(A0,ps(i));
        tic
        [Ys{i,j},i_y0s{i,j}] = simulate(@smp,As{i,j},y0s,Tmax,p_y0s,K);
        toc; beep
        durs{i,j} = durations(Ys{i,j});
        g = graph_from_matrix(As{i,j});
        e = g.Edges.EndNodes;
        w = g.Edges.Weight;
        save(['i=' num2str(i) '_' num2str(j)],'e','w')
    end
end
clear i j p A probs Y pat g e w
%% python-networkx: count simple cycles
%% fig3b
figure
mdur = cellfun(@mean,durs)';
x = cycle_count/sum(sum(A0>0));
y = mdur(:);
[c,p] = corr(x,y);
scatter(x,y,50,'k.')
prettify
f = polyfit(x,y,1);
x = min(x) : 1e-2 : max(x);
hold on
plot(x, x*f(1)+f(2),'r')
axis([-2 22 0 6])
hold off
clear x y z f




