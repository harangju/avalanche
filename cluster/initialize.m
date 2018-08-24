%% initialize network
[A, B] = network_create(prm);
A = scale_weights_to_criticality(A);

% rng(seed)
% A = A0;
% for n = 1 : N
%     og = find(A0(n,:));
%     A(n,og) = A0(n,og) - redistr;
%     new = randperm(N,1);
%     while new == og
%         new = randperm(N,1);
%     end
%     A(n,new) = redistr;
% end
