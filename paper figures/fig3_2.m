
%%
N = 10;
A0 = triu(ones(N)) - eye(N);
A0 = A0 .* 0.2;
B = ones(N,1);
%% rewire probabilities
ps = 0 : 0.1 : 1;
trials = 10;
durations = cell(length(ps),trials);
As = cell(length(ps),trials);
Ys = cell(length(ps),trials);
patses = cell(length(ps),trials);
%%
dur = 1e4; iter = 1e4;
[pats,probs] = pings_single(N);
for i = 1 : length(ps)
    for j = 1 : trials
        disp(num2str([i j]))
        As{i,j} = network_rewire(A0,ps(i));
        tic
        [Ys{i,j},patses{i,j}] = avl_smp_many(pats,probs,As{i,j},dur,iter);
        toc; beep
        durations{i,j} = avl_durations_cell(Ys{i,j});
        g = graph_from_matrix(As{i,j});
        e = g.Edges.EndNodes;
        w = g.Edges.Weight;
        save(['i=' num2str(i) '_' num2str(j)],'e','w')
    end
end
clear p A probs Y pat g e w

%%
alphas = zeros(length(ps),trials);
xmins = zeros(length(ps),trials);
devals = zeros(length(ps),trials);
for i = 1 : length(ps)
    for j = 1 : trials
        disp(num2str([i j]))
        [alphas(i,j), xmins(i,j)] = plfit(durations{i,j});
        devals(i,j) = eig_dom(As{i,j}');
        plplot(durations{i,j},xmins(i,j),alphas(i,j))
        prettify; drawnow
%         pause
    end
end

%% load cycle count from python

%%
mdur = cellfun(@mean,durations)';
x = cycle_count/sum(sum(A0>0));
y = mdur(:);
scatter(x,y,50,[3.1 18.8 42]./100,'.')
prettify
f = polyfit(x,y,1);
z = min(x) : 1e-2 : max(x);
hold on
plot(z, z*f(1)+f(2),'r')
axis([-2 22 0 6])
hold off
c = corr(x,y);




