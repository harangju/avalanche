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
avl_dur = cellfun(@durations,avl_emp,'uniformoutput',0);
clear i
%% find loops
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
%% fig3c
figure
clf
i = 1;
lps = [avl_lps{i}{:}];
% x = unique(lps);
x = 10.^(0:.05:max(lps));
y = histcounts(lps,[x max(x)+1]);
loglog(x,y,'.','MarkerSize',10,'Color',color)
prettify
xlabel('loop length (bin size)')
ylabel('counts')
clear i lps x y
%% bar graph of loop counts
lps_cnt_max = 4;
avl_lps_cnt = zeros(length(avl_lps),lps_cnt_max);
for i = 1 : length(avl_lps_cnt)
    e = [1:lps_cnt_max lps_cnt_max+1 max([avl_lps{i}{:}])];
    h = histcounts([avl_lps{i}{:}], e);
    avl_lps_cnt(i,:) = h(1:lps_cnt_max);
end
clear i e h
%% fig3d
figure
clf
avl_cnt = cellfun(@length,avl_emp)';
h = bar(avl_lps_cnt./avl_cnt,'stacked');
colors = linspecer(lps_cnt_max);
for i = 1 : lps_cnt_max
    h(i).FaceColor = colors(i,:);
end
prettify
xlim([0 26])
legend({'1-loop','2-loop','3-loop','4-loop'})
clear h i
