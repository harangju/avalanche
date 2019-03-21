function X = avl_smp(x0,A,T)
%avl_smp Avalanche generation via stochastic McCulloch-Pitts model
%   
%   Parameters:
%       x0 (float; n-by-1) initial state
%       A (float; n-by-n) column j -> row i connectivity
%       T (int) 
n = size(A,1);
X = zeros(n,T);
X(:,1) = x0;
for t = 2 : T
    X(:,t) = smp(X(:,t-1),A);
    if sum(X(:,t)) == 0
        break
    end
end
X = X(:,1:t);
end

