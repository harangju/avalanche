function [avalanches, idx_start] = detect_avalanches(bins)
%detect_avalanches
%   bins: binned spikes, [#neurons by time]

activity = [0 sum(bins, 1)];
idx_start = strfind(activity > 0, [0 1]);
idx_end = strfind(activity > 0, [1 0]);
avalanches = cell(1, length(idx_end));
for i = 1 : length(idx_end)
    avalanches{i} = bins(:, idx_start(i):idx_end(i));
end

end

