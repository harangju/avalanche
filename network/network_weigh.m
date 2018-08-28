function A = network_weigh(A, type, params)
%network_weigh Returns a weighted network
%   called by network_create
%
%   Example:
%       A = network_weigh(A, 'uniform', 1);
%       A = network_weigh(A, 'gaussian', [0.5 0.15]);
%       A = network_weigh(A, 'bimodalgaussian', [0.1 0.9 0.1]);
%       A = network_weigh(A, 'powerlaw', 3);
%
%   See also network_create, network_connect

by_neuron = true;

if by_neuron
    
else
    
end

weights = A(:);
[~,idx_sort] = sort(weights(weights>0));

new_weights = 0;

switch type
    case 'uniform'
        weight = params(1);
        new_weights = weight * ones(size(idx_sort));
    case 'gaussian'
        mu = params(1);
        sigma = params(2);
        new_weights = normrnd(mu, sigma, size(idx_sort));
        new_weights = sort(new_weights);
    case 'bimodalgaussian'
        mu1 = params(1);
        mu2 = params(2);
        sigma = params(3);
        new_weights = [normrnd(mu1, sigma, [length(idx_sort)/2 1]) ...
            normrnd(mu2, sigma, [length(idx_sort)/2 1])];
        new_weights = sort(new_weights);
    case 'powerlaw'
        alpha = params(1);
        new_weights = randht(length(idx_sort), 'powerlaw', alpha);
%     case 'SC' % streamline counts
%         warning('create_network(): streamline counts not implemented')
%     case 'FA' % fractional anistropy
%         warning('create_network(): fractional anistropy not implemented')
    otherwise
        warning('create_network(): undefined weighting')
end

idx_pos = find(weights);
A(idx_pos(idx_sort)) = new_weights;

end

