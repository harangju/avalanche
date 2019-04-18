function avl = avl_detect(data)
% avl_detect
%   data can be
%       cell array of spike times for each neuron
%       or N-by-T binned matrix

if iscell(data)
    spike_times = unique([data{:}]);
    isi = diff(spike_times);
    quiescence = find(isi>1);
    avl = 0;
    warning('Cell arrays not supported.')
else
    activity = [0 sum(data, 1)];
    idx_start = strfind(activity > 0, [0 1]);
    idx_end = strfind(activity > 0, [1 0]);
    avl = cell(1, length(idx_end));
    for i = 1 : length(idx_end)
        avl{i} = data(:, idx_start(i):idx_end(i));
    end
end
