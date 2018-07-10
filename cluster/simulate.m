
%% stimulus
pats = cell(1,param.num_nodes);
for i = 1 : param.num_nodes
    pats{i} = zeros(param.num_nodes,1);
    pats{i}(i) = 1;
end

%%
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc

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
save