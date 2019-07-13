function s = csc_sizes(Y)
% returns cascade duration for cell array, Y, of cascades
s = cellfun(@(x) sum(sum(x,2)>0),Y);
end

