function durations = avalanche_durations_cell(Y)
%avalanche_duration
%   Y: avalanches, {iter} x [neurons x duration]

iter = length(Y);
twos = num2cell(2*ones(1,iter));
durations = cellfun(@size,Y,twos) - 1;

end

