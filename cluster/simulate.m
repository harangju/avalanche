
%% stimulus
pats = cell(1,prm.N);
for i = 1 : prm.N
    pats{i} = zeros(prm.N,1);
    pats{i}(i) = 1;
end

%% simulate
probs = ones(1,length(pats)) / length(pats);
tic
% [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
[Y,pat] = trigger_many_avalanches_compact(A,B,pats,probs,dur,iter);
toc
