function bins = spike_times_to_bins(spike_times, bin_size)
%convert_from_spike_times(spike_times)
%   spike_times: cell array, integer spike times, [#neurons by #spikes]
% returns
%   bins: binned spikes, [#neurons by time]

N = length(spike_times);
spike_bins = bin_spike_times(spike_times, bin_size);
bin_max = max(cellfun(@max, spike_bins));
bins = zeros(N, bin_max);
for n = 1 : N
    bins(n, spike_bins{n}) = 1;
end

end

