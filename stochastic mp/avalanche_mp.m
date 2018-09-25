function X = avalanche_mp(x0,A,T)
%avalanche_mp
%   

N = size(A,1);
X = zeros(N,T);
X(:,1) = x0;
for t = 2 : T
    X(:,t) = mp_stochastic(X(:,t-1),A);
    if sum(X(:,t)) == 0
        break
    end
end

X = X(:,1:t);

end

