function a = find_cyclic_activity(cascades)
% a = find_cyclic_activity(cascades)
%   returns an array of N vectors for N neurons
%   each vector contains n's, where an n-cycle occurs when a neuron spikes
%   after having spiked n time bins before
N = size(cascades{1},1);
a = cell(1,N);
for i = 1 : length(cascades)
    [neurons, spike_times] = find(cascades{i});
    for k = unique(neurons)'
        a{k} = [a{k} diff(spike_times(neurons==k))'];
    end
end