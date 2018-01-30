function sizes = avalanche_size(A, B)
%avalanche_size finds sizes of avalanches
%   size is defined as the total number of neurons activated
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [N X 1]

N = size(A,1);
sizes = zeros(N,1);

for i = 1 : N
    avalanche = find_avalanche(A,B,i);
    nodes = [];
    for j = 1 : length(avalanche)
        nodes = [nodes; avalanche{j}];
    end
    sizes(i) = length(unique(nodes(:)));
end

end
