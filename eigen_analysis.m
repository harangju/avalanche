
% given A
deg = outdegree(A) + indegree(A);
A_conn = A(deg>0,deg>0);
g=graph_from_matrix(A_conn);
[v,u] = eig(A_conn);
u = diag(u);
[~,idx] = sort(u);
clf
eigenmags = zeros(size(A_conn,1),1);
for i = idx'
eigenmags = max(eigenmags, abs(v(:,i)));
end
subplot(1,2,1)
plot(g,'NodeCData',eigenmags,...
    'MarkerSize',5,...
    'LineWidth',2*g.Edges.Weight/max(g.Edges.Weight))
colorbar; set(gca,'visible','off'); axis square
subplot(1,2,2)
eigenmags = zeros(size(A_conn,1),1);
for i = idx'
eigenmags = max(eigenmags, u(i)*ones(size(eigenmags)));
end
