function phi = control_modal(A)
%control_modal
%   A: source X target
% returns
%   phi:

[v, d] = eig(A);
d = diag(d);
N = size(A,1);
phi = zeros(N,1);
for i = 1 : N
    phi(i) = 0;
    for j = 1 : N
        phi(i) = phi(i) + (1 - d(j)^2) * v(i,j)^2;
    end
end

end

