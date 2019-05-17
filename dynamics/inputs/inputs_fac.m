function y0s = inputs_fac(A,F,m)
% y0s = inputs_fac(A,F,m)
%   returns inputs with m active neurons ordered by finite average
%   controllability
fac = finite_impulse_responses(A, F);
N = size(A,1);
[~, order] = sort(fac);
y0s = cell(1, N/m);
for i = 1 : length(y0s)
    y0s{i} = zeros(N,1);
    y0s{i}(order(1+m*(i-1) : m*i)) = 1;
end