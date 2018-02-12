function A_pow = weigh_power(A)
%weigh_power
%   Returns a matrix that rank-orders the edge weights of the original 
%   weighted matrix and replaces those weights with the corresponding
%   weights from a power distribution
%   A: connectivity/weight matrix, [pre- X post-]
%   A_pow: A weighted by power law

error('not implemented')

alpha = -3; % slope of power
range = 0.12;

[~, idx] = sort(A(A>0));
power_val = (1-k) .^ (1/(1-alpha));
A_pow = A;
A_pow(A_pow>0) = power_val(idx);

end
