function avalanches = detect_avalanches(spike_times, bin_size)
%detect_avalanches
%   spike_times: 
%   bin_width: 

N = length(spike_times);
spike_bins = bin_spike_times(spike_times, bin_size);
bin_max = max(cellfun(@max, spike_bins));
bins = zeros(N, bin_max);
for n = 1 : N
    bins(n, spike_bins{n}) = 1;
end
activity = sum(bins, 1);
idx_start = strfind(activity > 0, [0 1]);
idx_end = strfind(activity > 0, [1 0]);
avalanches = cell(1, length(idx_start));
for i = 1 : length(idx_start)
    avalanches{i} = bins(:, idx_start:idx_end);
end

end

