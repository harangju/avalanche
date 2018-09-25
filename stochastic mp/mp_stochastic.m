function xn = mp_stochastic(x,A) %,B,u)
%
%   A: a NxN weight matrix, row i -> column j
%   x: a Nx1 column vector

A_norm = A ./ sum(A,1);
xn = double(rand(size(x)) < A_norm'*x);

end

