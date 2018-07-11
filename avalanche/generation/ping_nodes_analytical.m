function [Y, pat] = ping_nodes_analytical(A, B, dur)
%ping_nodes(A, B, iter, dur)
%   A: connectivity matrix
%   B: input connectivity vector
%   iter: # avalanches to trigger
%   dur: max duration of avalanches

input_nodes = find(B)';
Y = zeros(size(A,1), dur, length(input_nodes));
for i = input_nodes
	Y(:,:,i) = avalanche_average_analytical...
        (A,B,inputs(size(A,1),{i}),dur);
end
pat = input_nodes;

end

