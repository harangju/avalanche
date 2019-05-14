function [H,x,v] = avl_predictor(A, x0, T)
% A: [post- by pre-] !!! ATTENTION !!!
% x0: [N by 1]
% T: max duration
% returns
%   H: predictor of duration
%   x: predicted mean of spikes
%   v: predicted ceiling of variance

N = length(x0);
x = zeros(N, T);
v = zeros(N, T);
x(:,1) = x0;
% v(:,1) = x0;
v(:,1) = zeros(N,1);
for i = 2 : T
    x(:,i) = A*x(:,i-1);
    v(:,i) = (A - A.^2)*x(:,i-1) + A*v(:,i-1);
end
% H = mean(x./v, 'omitnan');
H = mean(x./v, 'omitnan').^(1/sum(x0));
% H = mean(x.^(1/sum(x0))./v, 'omitnan');
% H = prod(1-(x./v), 'omitnan').^(1/sum(x0));
H(isinf(H)) = 0;
H(isnan(H)) = 0;

end
