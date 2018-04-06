
% given A

%% create subnetwork
deg = outdegree(A) + indegree(A);
A_conn = A(deg>0,deg>0);
g=graph_from_matrix(A_conn);
%% eigen analysis
[v,u] = eig(A_conn);
u = diag(u);
[~,idx] = sort(u);
%% max eigenvector components
eigenmags = zeros(size(A_conn,1),1);
for i = idx'
eigenmags = max(eigenmags, abs(v(:,i)));
end
%% plot graphs
figure(1)
subplot(2,1,1)
plot(g,'NodeCData',eigenmags,...
    'MarkerSize',5,...
    'LineWidth',2*g.Edges.Weight/max(g.Edges.Weight))
colorbar; set(gca,'visible','off'); axis square
subplot(2,1,2)
plot(g,'NodeCData',modal_control(A_conn),...
    'MarkerSize',5,...
    'LineWidth',2*g.Edges.Weight/max(g.Edges.Weight))
colorbar; set(gca,'visible','off'); axis square
%% using eigenvectors as stimuli

%% duration as function of eigenvalues

%% mutual information as function of eigenvectors

%% random stimuli

%% duration a.f.o eigenvalues


%% mutual information a.f.o. eigenvalues


%%
clf; hold on
for i = idx(end-10:end)'
    bar(v(:,i)) 
end; hold off
axis square; prettify
%%
idx(end-10:end)'
u(idx(end-10:end))'

%%


%%
x0=-1*v(:,88); x=[];
for i=1:10; x=[x A_conn^i*x0]; end;
plot(x','LineWidth',2); prettify; axis square

%%
dur=20; iter=300;
pat_size = 2;
idx = {{n(randperm(length(n),pat_size))},...
        {n(randperm(length(n),pat_size))},...
        {n(randperm(length(n),pat_size))},...
        {n(randperm(length(n),pat_size))}...
        };
pats = {-1*v(:,idx(end-1)),};
[Yp,pat] = trigger_many_avalanches(A_conn,ones(size(A_conn,1),1),...
    pats, ones(1,length(pats))/length(pats),dur,iter);



