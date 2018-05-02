
%%
load('/Users/harangju/Developer/beggs data/DataSet2.mat')
%% detect avalanches
bin_size = 4;
avalanches = detect_avalanches(data.spikes, bin_size);
%% compute node participation
% how much a node participates in long avalanches
% per node, per avalanche, activation throughout avalanche
% per node, avalanche activation throughout avalanche
N = length(data.spikes);
part = cell(1,N);
for n = 1 : N
    for a = 1 : length(avalanches)
        aval = avalanches{a};
        part{n} = [part{n} find(aval(n,:))];
    end; clear a aval
end; clear n
%% summarize information
occur_mean = cellfun(@mean,part);
bar(occur_mean)
prettify; xlabel('neurons'); ylabel('mean occurrence in avalanche')
%%

