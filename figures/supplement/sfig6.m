%% detect avalanches
data_dir = 'beggs data';
files = dir([data_dir '/*.mat']);
bin_size = 2;
% avl_emp = cell(1,length(files));
bins = cell(1,length(files));
for i = 1 : length(files)
    disp(['Analyzing ' files(i).name '...'])
    load([data_dir '/' files(i).name]);
    bins{i} = spike_times_to_bins(data.spikes,bin_size);
    clear data
end
clear i
%%
T = min(cellfun(@length,bins));
bin_sum = zeros(T,length(files));
for i = 1 : length(files)
    bin_sum(:,i) = sum(bins{i}(:,1:T));
end
clear i
%%
for i = 1 : length(files)
    dlmwrite(['wilting/beggs' num2str(i) '.tsv'],...
        bin_sum(:,i),'delimiter','\t')
end
clear i
