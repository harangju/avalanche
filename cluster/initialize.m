%% set up environment
addpath(genpath('..'))
addpath(genpath('../../wu-yan-2018-code'))
%% initialize network
[A, B, C] = network_create(param);
A = A .* rand(size(A));
A = scale_weights_to_criticality(A);
