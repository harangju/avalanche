function [patterns, probs] = pings_single(N)

patterns = cell(1,N);
for i = 1 : N
    x = zeros(N,1);
    x(i) = 1;
    patterns{i} = x;
end

probs = ones(1,length(patterns)) / length(patterns);

end

