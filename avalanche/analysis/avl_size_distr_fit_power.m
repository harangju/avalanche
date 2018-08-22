function p = avl_size_distr_fit_power(edges, prob)
%avalanche_size_distr_power_fit(N, edges) returns fitted exponential
%curve
%   prob: probability of number of avalanches with size given in edges
%   edges: bin edges for avalanche size, in log10 space
% see avalanche_size_distr()

x = edges(prob>0)';
y = log10(prob(prob>0))';
% power_fit = fit(x, y, 'power1');
p = polyfit(x, y, 1);

end

