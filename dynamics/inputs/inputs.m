function u = inputs(N, nodes, val)
%inputs(N, nodes, val) Generates inputs
%   N: number of nodes
%   nodes: cell array of vectors of node indices
%   val: the value of the input

u = zeros(N, length(nodes));
for t = 1 : length(nodes)
    u(nodes{t}, t) = val;
end

end

