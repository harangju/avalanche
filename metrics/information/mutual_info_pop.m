function [mi_pop, code] = mutual_info_pop(Y,pat)
%mutual_info_pop(Y) returns mutual info of the whole network at time t
%   Y: avalanches, [neurons by duration by iterations]
%   pat: patterns, [iterations by 1]
%returns
%   mi: [1 by duration]

T = size(Y,2);
code = pop_code_by_step(Y);
mi_pop = zeros(1,T);
for t = 1 : T
    mi_pop(i) = mi(pat,code(:,t));
end

end

