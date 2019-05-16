function d = distribution(type, N, params)
%distribution Returns a 'type' distribution of 'N' values with parameters
%'params'
%   
%   Example:
%       d = distribution('uniform', 100, 0.1);
%       d = distribution('gaussian', 100, [1 0.15]);
%       d = distribution('bimodialgaussian', 100, ...
%
%   See also network_weigh

d = 0;
switch type
    case 'uniform'
        value = params(1);
        d = value * ones(1,N);
    case 'gaussian'
        mu = params(1);
        sigma = params(2);
        d = normrnd(mu, sigma, [1 N]);
        d = sort(d);
    case 'bimodalgaussian'
        mu1 = params(1);
        mu2 = params(2);
        frac1 = params(3);
        frac2 = params(4);
        sigma = params(5);
        d = [normrnd(mu1, sigma, ...
            [ceil(frac1 * N) 1]); ...
            normrnd(mu2, sigma, ...
            [floor(frac2 * N) 1])];
        d = sort(d);
    case 'powerlaw'
        alpha = params(1);
        d = randht(N, 'powerlaw', alpha);
        % function from Clauset's powerlaws package
%     case 'SC' % streamline counts
%         warning('create_network(): streamline counts not implemented')
%     case 'FA' % fractional anistropy
%         warning('create_network(): fractional anistropy not implemented')
    otherwise
        warning('distribution() undefined distribution type')
end