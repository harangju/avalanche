function X_t = avalanche_linear(A, B, u_t, max_duration)
%avalanche_average_analytical Models propagation of spikes as a linear
%system
%   
%   Parameters
%       A - system connectivity, [pre X post]
%       B - system input connectivity, [input X N]
%       u_t - input to system over time t, [N X t]
%       max_duration - max avalanche duration
%
%   Returns
%       X_t: activation over time

N = size(A,1); % number of neurons
X = zeros(N,1); % system state, [N X 1]
X_t = zeros(N,max_duration); % system state [N X 1] over time

for t = 1 : max_duration
    u = zeros(N,1);
    if t <= size(u_t,2)
        u = u_t(:,t);
    end
    X = A' * X + B .* u;
    X_t(:,t) = X;
    if sum(X) == 0 && t >= size(u_t,2); break; end
end
% X_t = X_t(:,1:t-1);

end
