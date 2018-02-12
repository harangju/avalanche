function A_norm = weigh_normal(A)
%weigh_normal 
%   Returns a matrix that rank-orders the edge weights of the original 
%   weighted matrix and replaces those weights with the corresponding
%   weights from a Gaussian, normal distribution
%   A: connectivity/weight matrix, [pre- X post-]
%   mu: mean of distribution
%   sigma: standard deviation of distribution
%   A_norm: A weighted by normal distribution

mu = 0.5;
sigma = 0.12;

[~, idx] = sort(A(A>0));
norm_val = normrnd(mu, sigma, [length(idx) 1]);
A_norm = A;
A_norm(A_norm>0) = norm_val(idx);

end

