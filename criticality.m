
%% parameters
N = 100;
prob_spike = 1e-3;
timesteps = 1e6;
%% simulation
A = ones(N)/N;
tic
Y = spontaneous_avalanches(A,ones(N,1),prob_spike,timesteps);
toc
%% analysis
durs = cellfun(@size,aval,num2cell(2*ones(1,length(aval))));
[c,e] = histcounts(durs);
scatter(log10(e(2:end)),log10(c),'.')
