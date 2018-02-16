function s = outdegree(A)
%outdegree 
%   A: the weight/connectivity matrix, [pre- X post-]
%   o: the outdegree

s = sum(A>0,2);

end
