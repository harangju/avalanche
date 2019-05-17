function f = fit_exp_power_law(x)
% f = fit_exp_power_law(x)
%   returns a MLE fit, f = [alpha tau], of an exponential power law on the
%   distribution of x
%   uses python & powerlaw (See README)
py.importlib.import_module('powerlaw');
py.importlib.import_module('mpmath');
fit = py.powerlaw.Fit(x,pyargs('xmin',min(x),'discrete',true));
% NOTE: this currently doesn't work because you can't access
% 'truncated_power_law' from fit in Matlab