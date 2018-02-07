function [Y_t, transitions] = trigger_avalanche(A, B, u_t)
%trigger_avalanche
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
% returns
%   Y_t: neuron firing over time
%   avalanche: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e1;

N = size(A,1); % number of neurons
Y = zeros(N,1); % system state, [N X 1]
% C = A > 0; % connectivity matrix

Y_t = zeros(N,max_iter); % firing
transitions = cell(1,max_iter);

for t = 1 : max_iter
    u = zeros(N,1);
    if t <= size(u_t,2)
        u = u_t(:,t);
    end
    
    
%     Y = A' * Y + B .* u;
%     Y_t(:,t) = Y;
%     if t > 1
%         X_prev_idx = find(Y_t(:,t-1));
%         source = C(X_prev_idx,:) .* X_prev_idx;
%         source(source==0) = [];
%         edges = sum(C(X_prev_idx,:)>0, 1)';
%         target_idx = find(edges);
%         target = repelem(target_idx, edges(target_idx));
%         transitions{t} = [source' target];
%     end
    if sum(Y) == 0; break; end
end

Y_t = Y_t(:,1:t);
transitions = transitions(1:t);

end
