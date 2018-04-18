function [T, S] = state_mapping(Y)
%vis_mapping
%   Y: [N x duration x iterations]
%   T: transition matrix b/t states
%   S: network states

dur = size(Y,2);
iter = size(Y,3);
S = pop_code(Y);
n_s = max(max(S));
T = zeros(n_s,n_s); % [pre x post]
for d = 2 : dur
     for i = 1 : iter
         c1 = S(d,i);
         c2 = S(d-1,i);
         T(c1,c2) = T(c1,c2) + 1;
     end
end

end

