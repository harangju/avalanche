function sizes = avl_size_empirical(A, B, num_trials, max_duration)
%avalanche_size_empirical finds sizes of avalanches empirically...
%   size is defined as the total number of neurons activated
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [N X 1]
%   num_trials: to generate avalanches
%   max_duration: of avalanches (this stops cycles)

N = size(A,1);
sizes = zeros(N,1);

for i = 1 : N
    u_t = zeros(N,1);
    u_t(i) = 1;
    X_t = avalanche_average_empirical(A, B, u_t, num_trials, max_duration);
    sizes(i) = sum(sum(X_t, 2) > 0);
end

end
