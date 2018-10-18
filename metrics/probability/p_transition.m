function ptrans = p_transition(A, states)
%p_transition
%
%   Parameters:
%       A: (N-by-N)
%       states: (N-by-2^N)
%
%   Results:
%       
%
%   Example:
%       

Sk = repmat(states, []);
Sl = ;

ptrans = prod(1 - Sk - A' * Sl, 1);

end