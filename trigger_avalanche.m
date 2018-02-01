function [transitions, X_t] = trigger_avalanche(A, B, u_t)
%trigger_avalanche
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
%   avalanche: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e2;

N = size(A,1); % number of neurons
X = zeros(N,1); % system state, [N X 1]

X_t = zeros(N,max_iter); % system state over time
transitions = cell(1,max_iter);

for t = 1 : max_iter
    u = zeros(N,1);
    if t <= size(u_t,2)
        u = u_t(:,t);
    end
    X = A' * X + B .* u;
    X_t(:,t) = X;
    if t > 1
        X_prev_idx = find(X_t(:,t-1));
        source = A(X_prev_idx,:) .* X_prev_idx;
        source(source==0) = [];
        edges = sum(A(X_prev_idx,:), 1)';
        target_idx = find(edges);
        target = repelem(target_idx, edges(target_idx));
        transitions{t} = [source' target];
    end
    if sum(X) == 0; break; end
end

X_t = X_t(:,1:t);
transitions = transitions(1:t);

end
