function c = convergence(A)
%convergence Calculates the convergence parameter for each node
%   convergence is the indegree scaled by the weights
%   A: the weight/connectivity matrix, [pre- X post-]
%   c: the parameter for each node

c = sum(A,1)';

end
