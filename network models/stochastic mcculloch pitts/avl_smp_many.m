function [X, order] = avl_smp_many(x0s,probs,A,T,K)
%
%
%   x0s: input patterns
%   probs: probabilty of patterns
%   A: weight matrix, pre-post
%   T: max duration
%   K: number of trials
%
%   Returns
%       X:
%       order: 1-by-K matrix
max_tics = 100;
X = cell(1,K);
prob_cumsum = cumsum(probs);
order = zeros(1,K);
fprintf([repmat('#',1,max_tics) '\n'])
for k = 1 : K
    if mod(k,int32(K/max_tics)) == 0; fprintf('.'); end
    pat = sum(int8(prob_cumsum < rand)) + 1;
    order(k) = pat;
    x0 = x0s{pat};
    X{k} = avl_smp(x0,A,T);
end
fprintf('\n')
end

