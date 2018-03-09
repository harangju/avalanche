function exp_fit = avalanche_size_distr_exp_fit(N, edges)
%avalanche_size_distr_slope(N, edges) returns fitted exponential
%curve
%   N: number of avalanches with size given in edges
%   edges: bin edges for avalanche size
% seee avalanche_size_distr()

x = edges(N>0)';
y = log10(N(N>0))';
exp_fit = fit(x, y, 'exp1');

end

