function c = communicability(A)
%communicability Returns Nx1 vector of communicability values, takes in NxN
%matrix of edge weights from row i to column j
%   
%   Example:
%       c = communicability([1 2; 3 4]);
%
%   See also 

D = diag(sum(A,2))^(-1/2);
c = exp(D*A*D);

end

