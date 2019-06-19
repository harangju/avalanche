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
%% avalanche shape collapse
scSNZ = zeros(size(Av));
scDrv2 = zeros(size(Av));
scSig = zeros(size(Av));
for i = 1 : length(Av)
    disp(['Computing avalanche collapse (i=' num2str(i) ')...'])
    % compute average temporal profiles
    avgProfiles = avgshapes(Av{i}.shape, Av{i}.duration, 'cutoffs', 4, 20);
    % plot all profiles
    figure
    hold on
    for iProfile = 1:length(avgProfiles)
        plot(1:length(avgProfiles{iProfile}), avgProfiles{iProfile});
    end
    hold off
    xlabel('Time Bin, t', 'fontsize', 14)
    ylabel('Neurons Active, s(t)')
    saveas(gcf,['shape_' files(i).name(1:end-4) '.png'])
    % compute shape collapse statistics (SC) and plot
    [scSNZ(i), scDrv2(i)] = avshapecollapse(avgProfiles, 'plot');
    scSig(i) = avshapecollapsestd(avgProfiles);
    % save figure
    title(['Mean Temporal Profiles ' files(i).name newline...
        '1/(sigma nu z) = ' num2str(scSNZ(i)) ' +/- '...
        num2str(scSig(i))])
    saveas(gcf,['sc_' files(i).name(1:end-4) '.png'])
end
clear i iProfile
%% distributions
datasets = 1:length(Av);
% datasets = [4 12 17 18 21 23];
% datasets = [7 11 13 15 16 25];
tau = cell(size(Av));
p_sz = cell(size(Av));
p_crit_sz = cell(size(Av));
ks_sz = zeros(size(Av));
alpha = cell(size(Av));
p_dr = cell(size(Av));
p_crit_dr = cell(size(Av));
ks_dr = zeros(size(Av));
snz = cell(size(Av));
%%
for i = datasets
    % size distribution (SZ)
    [tau{i}, ~, ~, ~, p_sz{i}, p_crit_sz{i}]...
        = avpropvals(Av{i}.size, 'size', 'plot');
    saveas(gcf,['sz_' files(i).name(1:end-4) '.png'])
    % duration distribution (DR)
    [alpha{i}, xminDR, xmaxDR, ~, p_dr{i}, p_crit_dr{i}]...
        = avpropvals(Av{i}.duration, 'duration', 'plot');
    saveas(gcf,['dr_' files(i).name(1:end-4) '.png'])
    % size given duration distribution (SD)
    snz{i} = avpropvals({Av{i}.size, Av{i}.duration},...
        'sizgivdur', 'durmin', xminDR, 'durmax', xmaxDR, 'plot');
    saveas(gcf,['sgd_' files(i).name(1:end-4) '.png'])
end
clear i xminDR xmaxDR
%% 
tau = cellfun(@(x) x{1}, tau);
p_sz = cellfun(@(x) x{1}, p_sz);
p_crit_sz = cellfun(@(x) x{1}, p_crit_sz);
alpha = cellfun(@(x) x{1}, alpha);
p_dr = cellfun(@(x) x{1}, p_dr);
p_crit_dr = cellfun(@(x) x{1}, p_crit_dr);
snz = cellfun(@(x) x(1), snz);
%% figure
