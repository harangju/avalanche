%% initialize network
[A, B, C] = network_create(param);
A = scale_weights_to_criticality(A);
