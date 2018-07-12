%% initialize network
[A, B, C] = network_create(param);
A = A .* rand(size(A));
A = scale_weights_to_criticality(A);
