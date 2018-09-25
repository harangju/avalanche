function [X, order] = avalanche_mp_many(x0s,probs,A,T,K)
%
%
%   x0s:
%   probs:
%   A:
%   T:
%   K:

N = size(A,1);
X = cell(1,K);
prob_cumsum = cumsum(probs);
order = zeros(1,K);

for k = 1 : K
    pat = sum(int8(prob_cumsum < rand)) + 1;
    order(k) = pat;
    x0 = x0s{pat};
    X{k} = avalanche_mp(x0,A,T);
end

end

