function avalanche = trigger_avalanche(A, B, anchors)
%trigger_avalanche 
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   anchors: index of neurons to start avalanche
%   avalanche: cell array of neuron indices at each step of avalanche

max_iter = 1e3;

N = size(A,1); % number of neurons
X = zeros(N,1); % system state, [N X 1]
u = zeros(N,1); % system input, [N X 1]
% seed anchor as input
u(anchors) = 1;
avalanche = {};
for i = 1 : max_iter
    if i == 1
        X = A' * X + B .* u;
        
    else
        X = A' * X;
    end
    if sum(X)==0; break; end
    avalanche{end+1} = find(X);
end

end
