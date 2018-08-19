
%%
N = 10;
A0 = triu(ones(N)) - eye(N);
% A0 = A0 ./ fliplr(1:N)';
A0 = A0 .* 0.2;
B = ones(N,1);
%%
pats = cell(1,N);
for i = 1 : N
    x = zeros(N,1);
    x(i) = 1;
    pats{i} = x;
end; clear i x
%% rewire probabilities
ps = 0 : 0.1 : 1;
trials = 10;
%%
durations = cell(length(ps),trials);

%%
for i = 1 : length(ps)
    for j = 1 : trials
        % rewire
        p = ps(i);
        A = network_rewire(A0,p);
        % simulation
        dur = 1e4; iter = 1e4;
        probs = ones(1,length(pats)) / length(pats);
        tic
        [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
        toc; beep
        durations{i,j} = cellfun(@length,Y) - 1;
        % save
        g = graph_from_matrix(A);
        e = g.Edges.EndNodes;
        w = g.Edges.Weight;
        save(['i=' num2str(i) '_' num2str(j)],'e','w')
    end
end

%%
for i = 1 : length(ps)
    for j = 1 : trials
        % durations
        [c_d,e_d,bin_idx] = histcounts(durations{i},iter);
        x = log10(e_d(2:end));
        y = log10(c_d/sum(c_d));
        x(isinf(y)) = [];
        y(isinf(y)) = [];
        % f = polyfit(x(1:20),y(1:20),1);
        f = polyfit(x,y,1);
        disp(f)
        % plot
        scatter(x,y,10,[3.1, 18.8, 42]./100,'filled')
        prettify; drawnow
        pause
    end
end


