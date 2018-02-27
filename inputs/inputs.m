function u = inputs(N, nodes)
%inputs Generates inputs
%   N: number of nodes
%   nodes: cell array of vectors of node indices

u = zeros(N, length(nodes));
for t = 1 : length(nodes)
    u(nodes{t}, t) = 1;
end

end

