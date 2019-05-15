function f = fraction_alive(d)
% returns the fraction of alive cascades at t given row vector of
% durations, d
f = mean((1:max(d))<=d');
end

