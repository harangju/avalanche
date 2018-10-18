function p1 = p_states(p0, T)
%p_states
%
%   Parameters
%       A: connectivity matrix, row-to-column, i-j
%       states: column vectors of states
%       p0: probability of being in initial states
%       ptrans: transition probabilities
%
%   Returns
%       p1: probability of being in states in the next time step

Ns = size(T,1);
p0s = repmat(p0, [1 Ns]);


end

