function info = mutual_info(Y, pattern, C)
%mutual_info Calculates the mutual information between patterns & firing at
%a time during an avalanche
%   Y: [num_nodes X max_duration X iterations] matrix
%   pattern: vector of pattern indices
%       See trigger_many_avalanches.m
%   C: output connectivity matrix
%returns
%   info: the mutual information of a node at time t during an avalanche
%       and the pattern

% N = size(Y,1);
output_nodes = find(C)';
max_dur = size(Y,2);
% info = zeros(N,max_dur);
info = zeros(length(output_nodes),max_dur);
if size(pattern,1) == 1; pattern = pattern'; end
% for n = 1 : N
for n = output_nodes
    for t = 1 : max_dur
        info(n, t) = mi(pattern, squeeze(Y(n, t, :)));
    end
end

end
