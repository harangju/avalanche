function pa = p_alive(x0,A,T)
%p_alive
%
%   Parameters
%       x0 - stimulus pattern/initial state
%       A - weight matrix, pre-post
%       T - duration for which to calculate the probabiltiies
%
%   Returns
%       pa - a vector of probability that a cascade starting with x0 is
%       alive, from t=1 to t=T
%
%   Examples
%       pa = p_alive([1 0]',[.5 .5; .5 .5],10);

xt = avalanche_linear(A,ones(size(A,1),1),x0,T);
pa = zeros(1,T);
for t = 1 : T
    pa(t) = prod(1-xt(:,t));
end

end

