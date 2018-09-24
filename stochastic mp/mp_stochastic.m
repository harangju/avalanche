function xn = mp_stochastic(x,A) %,B,u)
%
%   A: a NxN weight matrix, row i -> column j
%   x: a Nx1 column vector

xn = double(rand(size(x)) < A'*x);

end

