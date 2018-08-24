function s = avl_sizes_cell(Y)
% AVL_SIZE_CELL
%
%   AVL_SIZE_CELL(Y)
%
%   Example:
%       Y = trigger_

num_trials = length(Y);
s = zeros(1,num_trials);
for i = 1 : num_trials
    s(i) = avl_size(Y{i});
end

end