function bs = spike_times_to_bins(spike_times, bin_size)
%convert_from_spike_times(spike_times)
%   spike_times: cell array, integer spike times, [#neurons by #spikes]
%   bin_size: 
% returns
%   bs: binned spikes, [#neurons by ms]

N = length(spike_times);
spike_bins = bin_spike_times(spike_times, bin_size);
bin_max = max(cellfun(@max, spike_bins));
bs = zeros(N, bin_max);
for n = 1 : N
    bins = spike_bins{n};
    bins(bins==0) = [];
%     bs(n,bins) = bs(n,bins) + 1; % this removes #spikes in bins
    bs(n,unique(bins)) = bs(n,unique(bins)) + ...
        histcounts(bins,[unique(bins) max(bins)+1]); % this counts #spikes
end

end

