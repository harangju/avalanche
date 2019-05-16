function d = csc_durations(Y)
% returns cascade duration for cell array, Y, of cascades
d = cellfun(@(x) size(x,2)-1,Y);
end

