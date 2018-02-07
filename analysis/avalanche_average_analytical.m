function [X_t, transitions] = avalanche_average_analytical(A, B, u_t)
%avalanche_average_analytical
%   Analytically calculates the expected average avalanche
%   max_iter - maximum duration of avalanche
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
% returns
%   X_t: activation over time
%   transitions: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e2;

N = size(A,1); % number of neurons
X = zeros(N,1); % system state, [N X 1]
X_t = zeros(N,max_iter); % system state [N X 1] over time

for t = 1 : max_iter
    u = zeros(N,1);
    if t <= size(u_t,2)
        u = u_t(:,t);
    end
    X = A' * X + B .* u;
    X_t(:,t) = X;
    if sum(X) == 0; break; end
end

X_t = X_t(:,1:t);
transitions = avalanche_transitions(X_t, A);

end
