function [N, edges] = avalanche_size_distr_log(Y, num_bins)
%avalanche_size_distr(Y)
%   Y: avalanches, [#neurons X duration X #avalanches]
%   num_bins: number of bins to 
% returns
%   N: number of avalanches in bin
%   edges: edges of bin in log10 space

s = squeeze(avalanche_size(Y));
s_min = log10(min(s));
s_max = log10(max(s));
e = s_min : (s_max - s_min)/num_bins : s_max;
[N, edges] = histcounts(log10(s), e);
% s_min = min(s);
% s_max = max(s);
% e = s_min : (s_max - s_min)/num_bins : s_max;
% [N, edges] = histcounts(s, e);

end

