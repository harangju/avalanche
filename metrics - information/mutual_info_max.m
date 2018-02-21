function [mi_max, node, time] = mutual_info_max(info, C)
%mutual_info_max 
%   mi: [N X ] matrix
%   C: output nodes
%returns
%   mi_max: vector of max MI values (excluding zeros)
%   node: node idx
%   time: time of mi_max

node = find(C);
[mi_max, time] = max(info(node, :), [], 2);
node(mi_max<=0) = [];
time(mi_max<=0) = [];
mi_max(mi_max<=0) = [];

end
