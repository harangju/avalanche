function A = Cycles(N, cycle_size)
%Cycles creates an adjacency matrix of a network consisting of directional
%cycles
%   N: number of nodes
%   cycle_size: # nodes per cycle

nodes = 1 : N;
A = zeros(N,N);
weight = 1; %/cycle_size;

order = randperm(N, cycle_size*floor(N/cycle_size));
n_start = order(1);
n_prev = order(1);
for i = 2 : length(order)
    n = order(i);
    if mod(i, cycle_size) == 0
        A(n, n_start) = weight;
        A(n_prev, n) = weight;
    elseif mod(i, cycle_size) == 1
        n_start = n;
    else
        A(n_prev, n) = weight;
    end
    n_prev = n;
end

end

