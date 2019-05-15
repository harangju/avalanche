function Ym = csc_cell_to_mat(Y)
%   Ym = csc_cell_to_mat(Y)
%       returns Ym: matrix [#neurons X duration X trials] from Y: cell
%       array [1 X trials] of matrices [#neurons X duration]
d = durations(Y);
N = size(Y{1},1);
Ym = zeros(N, max(d), length(Y));
for i = 1 : length(Y)
    Ym(:, 1:d(i)+1, i) = Y{i};
end

end