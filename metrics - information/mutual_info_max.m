function [mi_max, node, time] = mutual_info_max(info, C, t_last_input)
%mutual_info_max 
%   mi: [N X ] matrix
%   C: output nodes
%   t_last_input: time of last input
%returns
%   mi_max: vector of max MI values (excluding zero MI's)
%   node: node idx (excluding input nodes)
%   time: time of mi_max

node = find(C);
[mi_max, time] = max(info(node, :), [], 2);
node(mi_max<=0) = [];
time(mi_max<=0) = [];
mi_max(mi_max<=0) = [];
node(time==t_last_input) = [];
mi_max(time==t_last_input) = [];
time(time==t_last_input) = [];

end
