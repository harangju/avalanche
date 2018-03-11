function aval = find_avalanches(Y)
%UNTITLED Summary of this function goes here
%   Y: spike trains, [N X t]
%   aval: avalacnhes, [N X t X avalanches]

activity = [sum(Y,1) 0]; % zero padding
idx_activity = find(activity);
idx_activity([false diff(idx_activity)==1]) = [];
idx_quiescence = find(activity == 0);
idx_quiescence([false diff(idx_quiescence)==1]) = [];
if length(idx_quiescence) > length(idx_activity)
    idx_quiescence(1) = [];
end
lengths = idx_quiescence - idx_activity;
aval = zeros(size(Y,1), max(lengths), length(idx_quiescence));
for i = 1 : length(lengths)
     aval(:,1:lengths(i),i) = Y(:,idx_activity(i):idx_quiescence(i)-1);
end

end

