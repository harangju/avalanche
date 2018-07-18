
%% acyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0 0 0];

%% cyclic 3-node graph
A = [0 0.5 0; 0 0 0.5; 0.5 0 0];

%%
N = 3;
B = ones(N,1);
%% simulation
% patterns
pats = cell(1,N);
for i = 1 : N
    pats{i} = zeros(N,1);
    pats{i}(i) = 1;
end
%%
dur = 1e3; iter = 1e4;
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%%
activity = squeeze(sum(Y,1))';
durations = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        durations(i) = find(activity(i,:)>0,1,'last');
    else
        durations(i) = 0;
    end
end; clear i
%%
% [c_d,e_d,bin_idx] = histcounts(durations,100);
[c_d,e_d,bin_idx] = histcounts(durations);
x = log10(e_d(2:end));
y = log10(c_d/sum(c_d));
x(isinf(y)) = [];
y(isinf(y)) = [];
% f = polyfit(x(1:20),y(1:20),1);
f = polyfit(x,y,1);
disp(f)
%%
colors = linspecer(2);
%%
c = 2;
scatter(x,y,'filled','MarkerEdgeColor',colors(c,:),...
    'MarkerFaceColor',colors(c,:))
prettify
%%
legend({'acyclic','cyclic'})
