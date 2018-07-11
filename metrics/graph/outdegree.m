function o = outdegree(A)
%outdegree 
%   A: the weight/connectivity matrix, [pre- X post-]
%   o: the outdegree

o = sum(A>0,2);

end
