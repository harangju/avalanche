function X = avl_linear_many(x0s,A,dur)
%UNTITLED Summary of this function goes herea
%   Detailed explanation goes here

N = size(A,1);
X = cell(1,length(x0s));
for i = 1 : length(x0s)
    X{i} = avalanche_linear(A,ones(N,1),x0s{i},dur);
end

end

