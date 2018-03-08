function g = graph_from_matrix(A)
%graph_from_matrix(A)
%   A: connectivity matrix

N = size(A,1);
source = mod(find(A),N);
source(source==0) = N;
target = repelem(1:N, sum(A>0))';
g = digraph(source,target);

end

