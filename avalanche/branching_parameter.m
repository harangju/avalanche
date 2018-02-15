function s = branching_parameter(A)
%branching_parameter Calculates the branching parameter for each node
%   A: the weight/connectivity matrix, [pre- X post-]
%   s: the parameters, sigma, for each node

s = sum(A,2);

end
