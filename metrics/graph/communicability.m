function c = communicability(A)
%
%   A: NxN weight matrix

D = diag(sum(A,2))^(-1/2);
c = exp(D*A*D);

end

