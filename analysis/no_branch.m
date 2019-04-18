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
%% plot individual avalanches
i = 1;
j = find(avl_dur{i}>50,1);
imagesc(avl_emp{i}{j})
clear i j
%% count
% how often neurons are active in an avalanche
avl_cnt = cell(size(avl_emp));
for i = 1 : length(avl_emp)
    disp(['Counting neurons in recording ' num2str(i) '/' ...
        num2str(length(avl_emp))])
    avl_cnt{i} = zeros(size(avl_emp{i}{1},1),...
        length(avl_emp{i}));
    for j = 1 : length(avl_emp{i})
        avl_cnt{i}(:,j) = sum(avl_emp{i}{j},2);
    end
end
clear i j
%% plot - counts
i = 3;
% x = unique(av_cnt{i}(av_cnt{i}>0))';
x = 10.^(0:.1:max(avl_cnt{i}(:)));
y = histcounts(avl_cnt{i}(avl_cnt{i}>0),[x max(x)+1]);
loglog(x,y/nnz(avl_cnt{i}),'.','MarkerSize',10)
prettify
clear i x y
%% interspike interval - whole recording
avl_isi = cell(size(avl_emp)); %ms
for i = 1 : length(avl_emp)
    disp(['Analyzing ' num2str(i) '/' num2str(length(avl_emp))])
    load([data_dir '/' files(i).name]);
    avl_isi{i} = cellfun(@diff,data.spikes,'uniformoutput',0);
end
clear i data
%% interspike interval - per cascade
avl_isi_csd = cell(size(avl_emp));
for i = 1 : length(avl_emp)
    disp(['Analyzing ' num2str(i) '/' num2str(length(avl_emp))])
end
clear i
%% plot - interspike intervals
i = 2;
% x = unique(floor(avl_isi{i}{j}));
% y = histcounts(avl_isi{i}{j},[x max(x)+1]);
% x = unique(floor([avl_isi{i}{:}]));
isi = [avl_isi{i}{:}];
x = 10.^(0:.1:max(isi));
y = histcounts(isi,[x max(x)+1]);
loglog(x,y,'.','MarkerSize',10)
set(gca,'FontSize',16)
xlabel('interspike interval (ms)')
ylabel('counts')
clear i j isi x y
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
%% plot - loops
i = 2;
lps = [avl_lps{i}{:}];
x = unique(lps);
y = histcounts(lps,[x max(x)+1]);
semilogy(x,y,'.','MarkerSize',10)
set(gca,'FontSize',16)
xlabel('loop length (bin size)')
ylabel('counts')
clear i lps x y
