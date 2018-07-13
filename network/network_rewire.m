function A = network_rewire(A, prob_rewire)
%rewires network edges (keeps source node same)
% with probability prob_rewire

N = size(A,1);
for n = 1 : N
    edges_old = find(A(n,:));
    to_change = rand(size(edges_old)) < prob_rewire;
    weights_to_change = A(n,edges_old(to_change));
    edges_new = randperm(N,sum(to_change>0));
    A(n,edges_old(to_change)) = 0;
    A(n,edges_new) = weights_to_change;
end

end

