 
%% detect avalanches
data_dir = 'beggs data';
files = dir([data_dir '/*.mat']);
bin_size = 2;
avl_emp = cell(1,length(files));
for i = 1 : length(files)
    disp(['Analyzing ' files(i).name '...'])
    load([data_dir '/' files(i).name]);
    bins = spike_times_to_bins(data.spikes,bin_size);
    avl_emp{i} = avl_detect(bins);
    clear bins data
end
avl_dur = cellfun(@avl_durations_cell,avl_emp,'uniformoutput',0);
clear i
%% find loops
i = 1;
j = find(avl_dur{i}>50,1);
imagesc(avl_emp{i}{j})
[neurons,spike_times] = find(avl_emp{i}{j});
avl_lps = cell(1,size(avl_emp{i}{j},1));
for k = unique(neurons)'
    avl_lps{k} = diff(spike_times(neurons==k));
end
%%
avl_lps = cell(1,length(avl_emp));
for i = 1 : length(avl_emp)
    disp(['Analyzing ' num2str(i) '/' num2str(length(avl_emp))])
    avl_lps{i} = cell(1,size(avl_emp{i}{1},1));
    for j = 1 : length(avl_emp{i})
        [neurons,spike_times] = find(avl_emp{i}{j});
        for k = unique(neurons)'
            avl_lps{i}{k} = [avl_lps{i}{k} diff(spike_times(neurons==k))'];
        end
    end
end
clear i j k neurons spike_times