% adopted from Neural Complexity Toolbox

%% load data
% files = dir([emp_data_dir '/*.mat']);
% Av = cell(length(files),1);
% for i = 1 : length(files)
%     disp(['Loading ' files(i).name '...'])
%     x = load([emp_data_dir '/' files(i).name]);
%     data.raster = bin_spike_times(x.data.spikes, 5);
%     Av{i} = avprops(data, 'ratio', 'fingerprint');
% end
% clear i x data
%% calculate power laws
pthresh = 0.2;
sz = cellfun(@(x) x.size, Av, 'un', 0);
dr = cellfun(@(x) x.duration, Av, 'un', 0);
%% variables
tau = cell(length(sz),1);
sz_min = cell(length(sz),1);
sz_max = cell(length(sz),1);
sigma_tau = cell(length(sz),1);
p_tau = cell(length(sz),1);
pcrit_tau = cell(length(sz),1);
alpha = cell(length(sz),1);
dr_min = cell(length(sz),1);
dr_max = cell(length(sz),1);
sigma_alpha = cell(length(sz),1);
p_alpha = cell(length(sz),1);
pcrit_alpha = cell(length(sz),1);
snz = cell(length(sz),1);
sigma_snz = cell(length(sz),1);
%% run
for i = 1 : length(sz)
    disp(['Recording ' num2str(i) '...'])
    [tau{i}, sz_min{i}, sz_max{i}, sigma_tau{i}, p_tau{i}, pcrit_tau{i}]...
        = avpropvals(sz, 'size', 'threshold', pthresh);
    [alpha{i}, dr_min{i}, dr_max{i}, sigma_alpha{i}, p_alpha{i}, ...
        pcrit_alpha{i}] = avpropvals(dr, 'duration', 'threshold', pthresh);
    [snz{i}, ~, ~, sigma_snz{i}] = avpropvals({sz{i}, dr{i}},...
        'sizgivdur', 'durmin', dr_min{i}{1}, 'durmax', dr_max{i}{1},...
        'threshold', pthresh);
end
clear i
%% figure
