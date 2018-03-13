function nodes = rich_club_nodes(A, k)
%rich_club_nodes(A,k) finds nodes of degree greater than k

degrees = indegree(A) + outdegree(A);
nodes = find(degrees > k);

end

