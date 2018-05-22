function Y_next = stochastic_spike_propagation(A, B, Y, u)
%stochastic_spike_propagation
%   A: connectivity weight matrix, [N X N]
%   B: input connectivity weight matrix, [N X N]
%   Y: current spikes, [N X 1]
%   u: inputs, [N X 1]

N = length(Y);
Y_next = binornd(u, B) + sum(binornd(repmat(Y,[1 N]),A), 1)';

end

