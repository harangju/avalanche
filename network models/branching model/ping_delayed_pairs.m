function [Y, pat] = ping_delayed_pairs(A, B, iter, dur)
%ping_nodes(A, B, iter, dur)
%   A: connectivity matrix
%   B: input connectivity vector
%   iter: # avalanches to trigger
%   dur: max duration of avalanches

input_nodes = find(B);
patterns = cell(1,length(input_nodes)^2);
for i = 1 : length(input_nodes)
    for j = 1 : length(input_nodes)
        patterns{(i-1)*length(input_nodes)+j} = ...
            {input_nodes(i) input_nodes(j)};
    end
end
[Y, pat] = trigger_many_avalanches(A, B, patterns, ...
    ones(1,length(input_nodes)^2)/length(input_nodes)^2, dur, iter);

end

