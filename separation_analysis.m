
% given criticality

%% avalanches
% driven mode, given A, B
iter = 1e4; dur = 6;
[Y, pat] = ping_nodes(A, B, iter, dur); beep
% [Y, pat] = ping_nodes_analytical(A, B, dur);

%% average avalanches
nodes_in = find(B)';
Y_pat = zeros(size(Y,1), size(Y,2), length(nodes_in));
for i = nodes_in
    Y_pat(:,:,i) = mean(Y(:,:,pat==i), 3);
end; clear i

%% distance measurement
dist_type = 'cosine';
dist = zeros(size(Y,1),size(Y,1), dur);
for t = 1 : dur
    % pdist, [observations X variables]
    % Y, [neurons X t X trials] -> [trials X neurons]
    dist(:,:,t) = squareform(pdist(squeeze(Y_pat(:,t,:))', dist_type));
end; clear t
%%
nodes = rich_club_nodes(A,4);
%%
nodes = 1:length(B);
%%
for i = 1 : dur
    subplot(2,3,i)
    imagesc(dist(nodes,nodes,i)); title(i)
    prettify; colorbar; axis square
    colormap jet
end

%% mutual information
C = ones(size(B));
mi_info = mutual_info(Y,pat,C);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);

%%
code = pop_code(Y,nodes);
mi_pop = zeros(1,dur);
for i = 1 : dur
    mi_pop(i) = mi(pat',code(i,:)');
end; clear i
plot(mi_pop, 'LineWidth', 2)
prettify; axis square; xlabel('t'); ylabel('MI'); axis([0 8 0 10])
%%



