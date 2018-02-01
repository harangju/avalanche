function sizes = avalanche_size(A, B)
%avalanche_size finds sizes of avalanches
%   size is defined as the total number of neurons activated
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [N X 1]

N = size(A,1);
sizes = zeros(N,1);

for i = 1 : N
    u_t = zeros(N,1);
    u_t(i) = 1;
    [~, trans] = trigger_avalanche(A,B,u_t);
    nodes = [];
    for j = 2 : length(trans)
        nodes = [nodes; trans{j}(:,2)];
    end
    sizes(i) = length(unique(nodes(:))) + 1;
end

end
