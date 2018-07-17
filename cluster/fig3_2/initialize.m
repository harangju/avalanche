%% initialize network
% [A, B, C] = network_create(param);
% A = Feedforward(N, frac_conn);
% A = network_rewire(A, p_rewire);
% B = ones(sum(N),1);

% A = A .* rand(size(A));
% A = scale_weights_to_criticality(A);

A = A0;
A(1,2) = A(1,2) - redistr;
A(1,1) = redistr;
A(2,1) = A(2,1) - redistr;
A(2,2) = redistr;
