function phi = rich_club_coeff(A, k)
%rich_club_coeff(A,k)
%   

degrees = indegree(A) + outdegree(A);
nodes = find(degrees > k);
subg = A(nodes,nodes);
Ek = sum(sum(subg>0));
Nk = length(nodes);
phi = 2*Ek/Nk/(Nk-1);

end

