function [x, y] = hist_log10(z,nbins)
%hist_log10(x)

[c,e] = histcounts(z,nbins);
x = [e(1:end-1); e(2:end)];
x = mean(x,1);
x = log10(x);
y = log10(c);
x(isinf(y)) = 0;
y(isinf(y)) = 0;
y(isinf(x)) = 0;
x(isinf(x)) = 0;

end

