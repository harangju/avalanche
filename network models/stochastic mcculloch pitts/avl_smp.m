function X = avl_smp(x0,A,T)
%avalanche_mp Avalanche generation via stochastic McCulloch-Pitts model
%   
%   Parameters:
%       x0 - 
%       A - 
%       T - 
%
%   Example:
%       X = stochastic_mp([1 0]', [])
%   
%   See also

N = size(A,1);
X = zeros(N,T);
X(:,1) = x0;
for t = 2 : T
    X(:,t) = smp(X(:,t-1),A);
    if sum(X(:,t)) == 0
        break
    end
end

X = X(:,1:t);

end

