function xn = smp(x,A)
%Stochastic McCulloch-Pitts model
%   A: a NxN weight matrix, column j -> row i
%   x: a Nx1 column vector
xn = double(rand(size(x)) < A*x);
end
