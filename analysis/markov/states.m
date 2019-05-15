function s = states(n)
% returns state space, s, given n parameters
dec = 0 : 2^n-1;
s = (fliplr(dec2bin(dec)) - '0')';
end