function [Y, pat] = ping_nodes(A, B, iter, dur)
%ping_nodes(A, B, iter, dur)
%   A: connectivity matrix
%   B: input connectivity vector
%   iter: # avalanches to trigger
%   dur: max duration of avalanches

input_nodes = find(B);
patterns = cell(1,length(input_nodes));
for i = 1 : length(input_nodes)
   patterns{i} = {input_nodes(i)};
end
[Y, pat] = trigger_many_avalanches(A, B, patterns, ...
    ones(1,length(input_nodes))/length(input_nodes), dur, iter);

end

