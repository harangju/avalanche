function vals = control_modal(A)
%control_modal
%   A:
% returns
%   vals:
%   

[v, d] = eig(A);
d = diag(d);
N = size(A,1);
phi = zeros(N,1);
for i = 1 : N
    phi(i) = v()
end

end

