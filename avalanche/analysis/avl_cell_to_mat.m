function Ym = avl_cell_to_mat(Y)
% Y: cell array [1 X trials] of matrices [#neurons X duration]
% Ym: matrix [#neurons X duration X trials]

durations = avl_durations_cell(Y);
N = size(Y{1},1);
Ym = zeros(N, max(durations), length(Y));

for i = 1 : length(Y)
    Ym(:, 1:durations(i)+1, i) = Y{i};
end

end