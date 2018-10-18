function p = p_state(si, S)
%p_state returns the state probability vector from states si in state space
%S
%
%   Parameter
%       si: column vectors of states, (N-by-#)
%       S: state space, (2^N-by-2^N)
%
%   Returns
%       p: probability vector of states, (2^N-by-1)

Ns = size(S,2);
idx = state_index(si,S);
p = zeros(Ns,1);
for i = 1 : length(idx)
    p(i) = p(i) + 1;
end
p = p / length(idx);

end