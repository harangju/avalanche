function [S, pInd] = A_propagate(A, x0, T)
% Function to propagate avalanche given initial condition vector x0 for T
% assume x0 is # trials (m) by # neurons (n)

[m, n] = size(x0);
S = zeros([m,T,n]);
S(:,1,:) = reshape(x0, [m,1,n]);

% XR = repmat(x0, [1,1,n]);
AR = repmat(reshape(A, [1,n,n]), [m,1,1]);
pInd = true(m,T);

for i = 2:T
    disp(i)
    S(pInd(:,i-1),i,:) = sum(binornd(repmat(S(pInd(:,i-1),i-1,:), [1,n,1]), AR(pInd(:,i-1),:,:)),3);
    pInd(:,i) = sum(S(:,i,:),3)>0;
end



end