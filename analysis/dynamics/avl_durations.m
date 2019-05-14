function durations = avl_durations(Y)
%avalanche_duration
%   Y: avalanches, [neurons by duration by trials]

iter = size(Y,3);
durations = zeros(1,iter);
activity = squeeze(sum(Y,1));
for i = 1 : iter
    dur = find(activity(:,i), 1, 'last');
    if ~isempty(dur); durations(i) = dur; end
end

end

