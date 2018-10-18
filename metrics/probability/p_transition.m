function T = p_transition(A, S)
%p_transition
%
%   Parameters:
%       A: weight matrix, (N-by-N), i-to-j, row-to-column
%       S: state matrix, (N-by-2^N)
%
%   Results:
%       T: state transition probabilities, (2^N-by-2^N), column-to-row such
%       that rows sum to 1
%
%   Example:
%       

Ns = size(S, 2);
Sk = repmat(S, [1 1 Ns]);
Sk = permute(Sk, [1 3 2]);

T = prod((1 - Sk) + (-1).^(Sk+1) .* repmat(A' * S, [1 1 Ns]), 1);
T = squeeze(T);

end