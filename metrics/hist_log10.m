function [x, y] = hist_log10(z,nbins)
%hist_log10(x)

[c,e] = histcounts(z,nbins);
x = [e(1:end-1); e(2:end)];
x = mean(x,1);
x = log10(x);
y = log10(c);
x(isinf(y)) = [];
y(isinf(y)) = [];
y(isinf(x)) = [];
x(isinf(x)) = [];

end

