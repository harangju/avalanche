function A = network_weigh(A, type, params, weigh_by_neuron)
%network_weigh Returns a weighted network
%   called by network_create
%
%   Example:
%       A = network_weigh(A, 'uniform', 1);
%       A = network_weigh(A, 'gaussian', [0.5 0.15]);
%       A = network_weigh(A, 'bimodalgaussian', ...
%           [0.1 0.9 0.9 0.1 0.1]);
%       A = network_weigh(A, 'powerlaw', 3);
%
%   See also network_create, network_connect

if strcmp(type, 'none')
    return
end

if weigh_by_neuron
    N = size(A,1);
    for n = 1 : N
        weights = A(n,:);
        [~,idx_sort] = sort(weights(weights>0));
        new_weights = distribution(type, length(idx_sort), params);
        idx_pos = find(weights);
        A(n,idx_pos(idx_sort)) = new_weights;
    end
else
    weights = A(:);
    [~,idx_sort] = sort(weights(weights>0));
    new_weights = distribution(type, length(idx_sort), params);
    idx_pos = find(weights);
    A(idx_pos(idx_sort)) = new_weights;
end

end
