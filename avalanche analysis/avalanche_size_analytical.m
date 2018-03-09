function sizes = avalanche_size_analytical(A, B, max_duration)
%avalanche_size finds sizes of avalanches
%   size is defined as the total number of neurons activated
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [N X 1]
%   max_duration: of avalanches (this stops cycles)

N = size(A,1);
sizes = zeros(N,1);

for i = 1 : N
    u_t = zeros(N, 1);
    u_t(i) = 1;
    X_t = avalanche_average_analytical(A, B, u_t, max_duration);
    sizes(i) = sum(sum(X_t, 2) > 0);
end

end
