function [Y, patterns] = trigger_many_avalanches(A, B, patterns, ...
    pattern_probs, max_duration, iterations)
%trigger_many_avalanches Calls trigger_avalanche many times
%   patterns: cell array of patterns
%       a pattern is a cell array of nodes to activate across time
%   pattern_probs: vector of probabilities for presenting the i^(th) pattern
%       sum(u_t_prob) should equal 1

Y = zeros(size(A,1), max_duration, iterations);

for i = 1 : iterations
    Y_t = trigger_avalanche(A, B, u_t, max_duration);
    Y(:, 1:size(Y_t,2), i) = Y_t;
end

end

