function xn = smp(A,x)
%Stochastic McCulloch-Pitts model
%   xn = smp(x)
%   A: a NxN weight matrix, column j -> row i
%   x: a Nx1 column vector
xn = single(rand(size(x)) < A*x);
end
