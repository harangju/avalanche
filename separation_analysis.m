
% given criticality

%% avalanches
% driven mode, given A, B
iter = 1e3; dur = 8;
[Y, pat] = ping_nodes(A, B, iter, dur); beep
% [Y, pat] = ping_nodes_analytical(A, B, dur);

%% average avalanches
nodes_in = find(B)';
Y_pat = zeros(size(Y,1), size(Y,2), length(nodes_in));
for i = nodes_in
    Y_pat(:,:,i) = mean(Y(:,:,pat==i), 3);
end; clear i

%% distance measurement
dist_type = 'euclidean';
dist = zeros(size(Y,1)*(size(Y,1)-1)/2, dur);
for t = 1 : dur
    % pdist, [observations X variables]
    % Y, [neurons X t X trials] -> [trials X neurons]
    dist(:,t) = pdist(squeeze(Y_pat(:,t,:))', dist_type);
end; clear t
dist(isnan(dist)) = 0;
plot(mean(dist(sum(dist,1)>0,:),1))

%% mutual information
mi_info = mutual_info(Y,pat,C);
[mi_max, mi_node, mi_time] = mutual_info_max(mi_info,C,1);
