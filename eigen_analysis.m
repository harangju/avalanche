
% given A
%%
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
plot(g,'NodeCData',modal_control(A_conn),...
    'MarkerSize',5,...
    'LineWidth',2*g.Edges.Weight/max(g.Edges.Weight))
colorbar; set(gca,'visible','off'); axis square

%%
clf; hold on
for i = idx(end-10:end)'
    bar(v(:,i))
end; hold off
axis square; prettify

%%
idx(end-5:end)'
u(idx(end-5:end))'
x0=-1*v(:,88); x=[];
for i=1:10; x=[x A_conn^i*x0]; end;
plot(x','LineWidth',2); prettify; axis square

%%
[Yp,pat] = trigger_many_avalanches(A_conn,ones(size(A_conn,1),1),...
    {{n(randperm(length(n),2))},...
        {n(randperm(length(n),2))},...
        {n(randperm(length(n),2))}}, [1 1 1]/3,10,100);



