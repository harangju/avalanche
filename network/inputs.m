function u = inputs(N, dur, nodes)
%inputs Generates inputs
%   N: number of nodes
%   dur: duration of inputs, time units
%   nodes: cell array of vectors of nodes to activate

u = zeros(N, dur);
for t = 1 : length(nodes)
    u(nodes{t}, t) = 1;
end

end

