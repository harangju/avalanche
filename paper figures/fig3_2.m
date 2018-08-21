
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
dur = 1e4; iter = 1e4;
for i = 1 : length(ps)
    for j = 1 : trials
        % rewire
        p = ps(i);
        A = network_rewire(A0,p);
        % simulation
        probs = ones(1,length(pats)) / length(pats);
        tic
        [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
        toc; beep
        durations{i,j} = avalanche_durations_cell(Y);
        % save
        g = graph_from_matrix(A);
        e = g.Edges.EndNodes;
        w = g.Edges.Weight;
        save(['i=' num2str(i) '_' num2str(j)],'e','w')
    end
end
clear p A probs Y pat g e w

%%
fits = zeros(length(ps),trials,2);
for i = 1 : length(ps)
    for j = 1 : trials
        % durations
        [c_d,e_d,bin_idx] = histcounts(durations{i,j},iter);
        x = log10(e_d(2:end));
        y = log10(c_d/sum(c_d));
        x(isinf(y)) = [];
        y(isinf(y)) = [];
        fits(i,j,:) = polyfit(x(5:min([length(x) 20])),...
            y(5:min([length(y) 20])),1);
        % plot
        scatter(x,y,10,[3.1, 18.8, 42]./100,'filled')
        hold on
        plot(0:0.1:3,fits(i,j,1)*(0:0.1:3) + fits(i,j,2))
        hold off
        axis([0 3 -5 0])
        prettify; drawnow
        pause(0.1)
    end
end

%% load cycle count from python

%% compare slopes to cycle counts
slopes = fits(:,:,1)';
scatter(log10(cycle_count/sum(sum(A0>0))),...
    slopes(:),...
    200, [3.1 18.8 42]./100, '.')
prettify
% axis([-2 15 -15 0])
% axis()




