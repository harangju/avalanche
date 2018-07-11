function binned = bin_spike_times(spike_times, bin_width)
%bin_spike_times
%   spike_times: cell array of spike_times
%   bin_width: integer

div = @(v) floor(v/bin_width);
binned = cellfun(div, spike_times, 'un', 0);

end

