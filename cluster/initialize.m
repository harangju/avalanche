%% initialize network
% [A, B, C] = network_create(param);
% A = Feedforward(N, frac_conn);
% A = network_rewire(A, p_rewire);
% B = ones(sum(N),1);

% A = A .* rand(size(A));
% A = scale_weights_to_criticality(A);

rng(seed)
A = A0;
for n = 1 : N
    og = find(A0(n,:));
    A(n,og) = A0(n,og) - redistr;
    new = randperm(N,1);
    while new == og
        new = randperm(N,1);
    end
    A(n,new) = redistr;
end
