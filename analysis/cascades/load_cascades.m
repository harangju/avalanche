function [cascades, spikes, files] = load_cascades(emp_data_dir)
% cascades = load_cascades(emp_data_dir)
%   returns a cell array of cascade from empirical data (see README)

bin_size = 5;

files = dir([emp_data_dir '/*.mat']);
cascades = cell(length(files),1);
spikes = cell(length(files),1);
for i = 1 : length(files)
    disp(['Analyzing ' files(i).name '...'])
    x = load([emp_data_dir '/' files(i).name]);
    data = x.data;
    spikes{i} = spike_times_to_bins(data.spikes, bin_size);
    cascades{i} = detect_cascades(spikes{i});
end
