function [Y_t, transitions] = trigger_avalanche(A, B, u_t)
%trigger_avalanche
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
% returns
%   Y_t: neuron firing over time
%   avalanche: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e2;

N = size(A,1); % number of neurons
C = A > 0; % connectivity matrix

Y_t = zeros(N,max_iter); % firing
u_t = padarray(u_t, [0 max_iter-size(u_t,2)], 'post'); % add zero padding to u_t
transitions = cell(1,max_iter);

for t = 1 : max_iter
    for j = 1 : N % firing Y, neuron i -> neuron j
        spikes_u = sum(rand(u_t(j,t),1) < B(j));
        spikes_Y_j = 0;
        if t > 1
            for i = 1 : N
                spikes_Y_j = spikes_Y_j + sum(rand(Y_t(i,t-1),1) < A(i,j));
            end
        end
        Y_t(j,t) = Y_t(j,t) + spikes_u + spikes_Y_j;
    end
    if t > 1 % transitions
        Y_prev_idx = find(Y_t(:,t-1));
        source = C(Y_prev_idx,:) .* Y_prev_idx;
        source(source==0) = [];
        edges = sum(C(Y_prev_idx,:)>0, 1)';
        target_idx = find(edges);
        target = repelem(target_idx, edges(target_idx));
        transitions{t} = [source' target];
    end
    if sum(Y_t(:,t)) == 0; break; end
end

Y_t = Y_t(:,1:t);
transitions = transitions(1:t);

end
