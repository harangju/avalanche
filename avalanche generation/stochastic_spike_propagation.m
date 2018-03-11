function Y_next = stochastic_spike_propagation(A, B, Y, u)
%stochastic_spike_propagation
%   A: connectivity weight matrix, [N X N]
%   B: input connectivity weight matrix, [N X N]
%   Y: current spikes, [N X 1]
%   u: inputs, [N X 1]

Y_next = zeros(length(Y),1);
for j = 1 : length(Y)
    Y_next(j) = Y_next(j) + sum(rand(1,u(j)) < B(j));
    for i = 1 : length(Y)
        Y_next(j) = Y_next(j) + sum(rand(1,Y(i)) < A(i,j));
    end
end

end

