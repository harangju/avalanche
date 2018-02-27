function s = avalanche_size(Y)
%avalanche_size Calculates avalanche size given an avalanche Y (without
%without triggering any avalanches)
%   Y: [N X duration] matrix, avalanche

s = sum(sum(Y>0,2)>0);

end

