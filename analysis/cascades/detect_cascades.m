function [cascades, idx_start] = detect_cascades(bins)
% [cascades, idx_start] = detect_cascades(spikes)
%   returns cell array of cascades & their starting indices given a N-by-T
%   matrix of spikes
activity = [0 sum(bins, 1)];
idx_start = strfind(activity > 0, [0 1]);
idx_end = strfind(activity > 0, [1 0]);
cascades = cell(1, length(idx_end));
for i = 1 : length(idx_end)
    cascades{i} = bins(:, idx_start(i):idx_end(i));
end

end