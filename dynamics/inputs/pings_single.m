function [y0s, p_y0s] = pings_single(N)
%   [y0s, p_y0s] = pings_single(N)
%       returns a cell array, y0s, of one-hot column vectors with length N
%       and a vector, p_y0s, with components 1/N
y0s = cell(1,N);
for n = 1 : N
    x = zeros(N,1);
    x(n) = 1;
    y0s{n} = x;
end
p_y0s = ones(1,N)/N;
end

