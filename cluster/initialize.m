%% initialize network
% [A, B, C] = network_create(param);
A = Feedforward(N, frac_conn);
B = ones(sum(N),1);

% A = A .* rand(size(A));
A = scale_weights_to_criticality(A);
