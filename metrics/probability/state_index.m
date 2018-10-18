function idx = state_index(si,S)
%state_index
%
%   Parameters
%       si: state vector
%       S: state space
%       
%   Returns
%       idx: index of si in S

[~,idx] = ismember(si',S','rows');

end