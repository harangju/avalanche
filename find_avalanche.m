function avalanche = find_avalanche(A, B, anchors)
%find_avalanche 
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   anchors: index of neurons to start avalanche
%   avalanche: cell array of transitions,
%       e.g. [1 2; 1 3] -> transitions from node 1 to nodes 2 and 3

max_iter = 1e3;

N = size(A,1); % number of neurons
X = zeros(N,1); % system state, [N X 1]
u = zeros(N,1); % system input, [N X 1]

% remove uncontrollable inputs
a = zeros(size(B));
a(anchors) = 1;
anchors = find(B & a); % column vector b/c B is column vector

avalanche = {[zeros(size(anchors)) anchors]};

for i = 1 : max_iter
    step = [];
    for j = 1 : size(avalanche{i},1)
        current_node = avalanche{i}(j,2);
        next_nodes = find(A(current_node,:))';
        step = [step; current_node * ones(size(next_nodes)) next_nodes];
    end
    if length(step) == 0; break; end
    avalanche{end+1} = step;
end

end
