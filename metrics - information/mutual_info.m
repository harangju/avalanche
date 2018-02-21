function info = mutual_info(Y, pattern_idx)
%mutual_info Calculates the mutual information between patterns & firing at
%a time during an avalanche
%   pattern_idx: vector of indices of patterns, [1 X number of patterns]
%   patterns: cell array of patterns
%       a pattern is a cell array of nodes to activate across time
%   Y: [num_nodes X max_duration X iterations] matrix
%       See trigger_many_avalanches.m
%returns
%   info

N = size(Y,1);
max_dur = size(Y,2);
info = zeros(N,max_dur);
for n = 1 : N
    for t = 1 : max_dur
        info(n, t) = mi(pattern_idx', squeeze(Y(n, t, :)));
    end
end

end
