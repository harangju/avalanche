function xn = stochastic_mcculloch_pitts(x,A)
%
%   A: a NxN weight matrix, row i -> column j
%   x: a Nx1 column vector

A_norm = A ./ sum(A,1);
xn = double(rand(size(x)) < A_norm'*x);

end

