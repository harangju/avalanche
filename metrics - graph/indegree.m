function i = indegree(A)
%indegree 
%   A: the weight/connectivity matrix, [pre- X post-]
%   i: the indegree

i = sum(A>0,1)';

end