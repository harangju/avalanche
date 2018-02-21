function C = shuffle_output_nodes(N, B, num_nodes_output)
%UNTITLED6 Summary of this function goes here
%   N: number of nodes
%   B: connectivity for inputs
%   num_nodes_output

idx = 1:N;
idx(B>0) = [];
num_nodes_hidden = N - sum(B>0) - num_nodes_output;
idx(randperm(length(idx), num_nodes_hidden)) = [];
C = zeros(N,1);
C(idx) = 1;

end
