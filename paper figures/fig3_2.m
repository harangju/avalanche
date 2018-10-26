
%%
N = 10;
A0 = triu(ones(N)) - eye(N);
A0 = A0 .* 0.15;
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

%% compare slopes to cycle counts
slopes = fits(:,:,1)';
x = log10(cycle_count/sum(sum(A0>0)));
y = slopes(:);
y(isinf(x)) = 0;
x(isinf(x)) = 0;
scatter(x, y, 200, [3.1 18.8 42]./100, '.')
prettify

%% log
f = polyfit(x, y, 1);
p = min(x) : 0.01 : max(x);
hold on
plot(p,polyval(f,p),'r')
hold off







