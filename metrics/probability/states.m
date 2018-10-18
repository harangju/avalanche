function s = states(N)
%states
%
%   Parameters
%       N: # parameters
%       -symbols: [array of symbols]- (leave as binary)
%
%   Returns
%       s: state space

dec = 0 : 2^N-1;
s = (fliplr(dec2bin(dec)) - '0')';

end