function [X, pind] = avl_smp_many(x0s,probs,A,T,K)
%avl_smp_many 
%   x0s (n-by-p) input patterns
%   probs (1-by-p) probabilty of patterns
%   A (float; n-by-n) weight matrix, column j -> row i
%   T (int) max duration
%   K (int) number of trials
%
%   Returns
%       X (n-by-K) states
%       pind (1-by-K) pattern index
max_tics = 100;
X = cell(1,K);
prob_cumsum = cumsum(probs);
pind = zeros(1,K);
fprintf([repmat('#',1,max_tics) '\n'])
for k = 1 : K
    if mod(k,int32(K/max_tics)) == 0; fprintf('.'); end
    pat = sum(int8(prob_cumsum < rand)) + 1;
    pind(k) = pat;
    x0 = x0s{pat};
    X{k} = avl_smp(x0,A,T);
end
fprintf('\n')
end

