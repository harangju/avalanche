function g = graph_from_matrix(A)
%graph_from_matrix(A)
%   A: connectivity matrix

N = size(A,1);
% source = mod(find(A),N);
% source(source==0) = N;
% target = repelem(1:N, sum(A>0))';
% g = digraph(source,target);
% g = digraph();
source = [];
target = [];
weights = [];
for i = 1 : N
    for j = 1 : N
        if A(i,j) > 0
%             source = [source i];
%             target = [target j];
            source = [source j];
            target = [target i];
            weights = [weights A(i,j)];
        end
    end
end
g = digraph(source, target, weights);

end
