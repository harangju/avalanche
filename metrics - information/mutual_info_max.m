function [mi_max, time] = mutual_info_max(info, C)
%mutual_info_max 
%   mi: [N X ] matrix
%   C: output nodes
%returns
%   mi_max: [N X 1] vector of maximum MI values
%   time: time at which MI is maximum

[mi_max, time] = max(info(find(C), :), [], 2);

end

