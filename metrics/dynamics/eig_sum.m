function e = eig_sum(A)
%eig_sum(A) returns the sum of the absolute value of the eigenvalues of A
%
%   Parameters:
%       A: (N-by-N) with source-target as column-to-row
%
%   Returns:
%       e: sum of absolute values of eigenvalues

[~,d] = eig(A);
e = sum(abs(diag(d)));

end