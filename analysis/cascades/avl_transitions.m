function transitions = avl_transitions(X_t, A)
%avalanche_transitions Calculates transitions given activations &
%connectivity
%   X_t: activation over time
%   A: system connectivity, [pre X post]
% returns
%   transitions: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = size(X_t, 2);
transitions = cell(1, max_iter);
C = A > 0; % connectivity matrix

for t = 2 : max_iter
    X_prev_idx = find(X_t(:,t-1));
    source = C(X_prev_idx,:) .* X_prev_idx;
    source(source==0) = [];
    edges = sum(C(X_prev_idx,:)>0, 1)';
    target_idx = find(edges);
    target = repelem(target_idx, edges(target_idx), 1);
    transitions{t} = [source' target];
end

end
