function [mi_pop, code] = mutual_info_pop(Y,pat)
%mutual_info_pop(Y) returns mutual info of the whole network at time t
%   Y: avalanches, [neurons by duration by iterations]
%   pat: patterns, [iterations by 1]
%returns
%   mi: [1 by duration]

code = pop_code_by_step(Y);
T = size(Y,2);
mi_pop = zeros(1,T);
for i = 1 : T
    mi_pop(i) = mi(pat,code(:,i));
%     code = pop_code(squeeze(Y(:,i,:)));
%     mi_pop(i) = mi(pat,code);
end

end

