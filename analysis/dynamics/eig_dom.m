function [deigval, deigvec] = eig_dom(A)
%eig_dom(A) returns the dominant eigenvalue and eigenvector of the system
%x(t+1) = Ax
%
%   Parameters:
%       A: (N-by-N) with source-target as column-to-row
%
%   Returns:
%       deigval: dominant eigenvalue
%       deigvec: " eigenvector

[v,d] = eig(A);
d = diag(d);
[deigval, idx] = max(real(d));
if abs(min(real(d))) > deigval
    deigval = min(real(d)) * -1;
end
deigvec = v(:,idx);

end