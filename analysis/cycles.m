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
%%
avl_cnt_mean = mean(cellfun(@length,avl_emp));
avl_cnt_se = std(cellfun(@length,avl_emp))./sqrt(length(avl_emp));
%% color
color = [3.1, 18.8, 42]/100;
%% plot - counts
i = 3;
% x = unique(av_cnt{i}(av_cnt{i}>0))';
x = 10.^(0:.1:max(avl_cnt{i}(:)));
y = histcounts(avl_cnt{i}(avl_cnt{i}>0),[x max(x)+1]);
loglog(x,y/nnz(avl_cnt{i}),'.','MarkerSize',10)
prettify
clear i x y
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
figure(1)
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
%%
figure(2)
clf
% h = bar(avl_lps_cnt./cellfun(@length,avl_emp)','stacked');
h = bar(avl_lps_cnt,'stacked');
% set(gca,'YScale','log')
colors = linspecer(lps_cnt_max);
for i = 1 : lps_cnt_max
    h(i).FaceColor = colors(i,:);
end
prettify
xlim([0 26])
legend({'1-loop','2-loop','3-loop','4-loop'})
clear h i
%% #cycles vs duration/eigenvalue
[ce_r_t,ce_p_t] = corr(sum(avl_lps_cnt,2),ft_pl_t_emp','Type','Spearman');
[ce_p_a,ce_r_a] = corr(sum(avl_lps_cnt,2),ft_pl_a_emp','Type','Spearman');
% [ce_r_e,ce_p_e] = corr(sum(avl_lps_cnt,2),cv_me');
figure(3)
semilogy(sum(avl_lps_cnt,2),ft_pl_t_emp,'.','MarkerSize',10)


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
    avl_isi_csd{i} = 0;
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
%% ISI summary
isi_max = 6;
% isi_ceil = 10;
avl_isi_sum = zeros(length(avl_isi),isi_max);
for i = 1 : length(avl_emp)
%     e = [1:isi_max isi_ceil max([avl_isi{i}{:}])];
    e = [1:isi_max max([avl_isi{i}{:}])];
    h = histcounts([avl_isi{i}{:}],e);
    avl_isi_sum(i,:) = h(1:isi_max);
end
clear i e h
%% plot
figure(4)
clf
% h = bar(avl_lps_cnt./cellfun(@length,avl_emp)','stacked');
h = bar(avl_isi_sum(:,1:isi_max),'stacked');
set(gca,'YScale','log')
colors = linspecer(isi_max);
for i = 1 : isi_max
    h(i).FaceColor = colors(i,:);
end
prettify
xlim([0 26])
legend({'ISI=1ms','ISI=2ms','ISI=3ms','ISI=4ms','ISI=5ms','5ms<ISI<=10ms'})
clear h i

