function f = avl_fraction_alive(Y)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

duration = avl_durations_cell(Y);
f = mean((1:max(duration))<=duration');

end

