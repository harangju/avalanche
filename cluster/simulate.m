
%% stimulus
[pats, probs] = pings_single(N);
tic
[Y, order] = avl_smp_many(pats, probs, A, dur, iter);
toc
