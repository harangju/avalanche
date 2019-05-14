function [P, a] = MC_transition(A, m, N)
% Estimates probability matrix based on Monte Carlo simulations of Bin.
n = size(A,1);
PS = reshape(1:((m+1)^n), repmat(m+1, 1, n));
P = zeros((m+1)^n);


% Compute all States up to m spikes
vectO = [1:n]';             % Permutation order
% Rotate matrix across through permutations of homogeneous variables
rot = zeros(n);
rot(1:end-1, 2:end) = eye(n-1); 
rot(end,1) = 1;
aMat = repmat([0:m]', [1, repmat((m+1), 1, n-1)]);
a = zeros([n, (m+1)^n]);
for i = 1:n
    AM = permute(aMat, (rot^(i-1) * vectO)');
    a(i,:) = AM(:);
end

aR = repmat(reshape(a', [1,size(a,2),n]), [n,1,1]);
aRC = num2cell(a+1);
AR = repmat(reshape(A, [n,1,n]), [1,size(a,2),1]);

for i = 1:N
    sP = sum(binornd(aR, AR),3);
    sPC = num2cell(sP+1);
    for j = 1:size(a,2)
        if(sum(sP(:,j) > m) == 0)
%             [sPC{:,j}]
            P(PS(sPC{:,j}), PS(aRC{:,j})) = P(PS(sPC{:,j}), PS(aRC{:,j})) + 1;
        end
    end
end
P = P ./ repmat(N, [1, size(P,2)]);



end