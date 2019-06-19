% adopted from Neural Complexity Toolbox
%
% Before running,
% set variable emp_data_dir (e.g., emp_data_dir = '/Users/name/data';)
% set variable idx_data (e.g., idx_data = 1;)

%% load data
bin_width = 5;
disp(['Loading ' emp_data_dir '"/DataSet' num2str(idx_data) '.mat"...'])
x = load([emp_data_dir '/DataSet' num2str(idx_data) '.mat']);
data.raster = bin_spike_times(x.data.spikes, bin_width);
Av = avprops(data, 'ratio', 'fingerprint');
clear x data
%% calculate power laws
[tau, sz_min, sz_max, sigma_tau, p_tau, pcrit_tau] =...
    avpropvals(Av.size, 'size');
[alpha, dr_min, dr_max, sigma_alpha, p_alpha, pcrit_alpha] =...
    avpropvals(Av.duration, 'duration');
[snz, ~, ~, sigma_snz] = avpropvals({Av.size, Av.duration},...
    'sizgivdur', 'durmin', dr_min, 'durmax', dr_max);
