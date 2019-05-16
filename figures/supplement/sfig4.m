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
%% branching parameter
avl_bp = cell(1,length(files));
avl_sz = cell(1,length(files));
for i = 1 : length(files)
    disp(['Analyzing ' num2str(i) '/' num2str(length(avl_bp))])
    avl_bp{i} = cell(1,length(avl_emp{i}));
    avl_sz{i} = cell(1,length(avl_emp{i}));
    for j = 1 : length(avl_emp{i})
        a = sum(avl_emp{i}{j},1);
        avl_bp{i}{j} = a(2:end-1)./a(1:end-2);
        avl_sz{i}{j} = a(1:end-2);
    end
end
clear i j a
%%
i = 8;
figure(1)
clf
hold on
plot([avl_sz{i}{:}],[avl_bp{i}{:}],'k.','MarkerSize',10)
xlim([0 max([avl_sz{i}{:}])])
prettify
clear i
%% corr
ce_sz_bp_r = zeros(1,length(avl_bp));
ce_sz_bp_p = zeros(1,length(avl_bp));
for i = 1 : length(avl_bp)
    disp(['Analyzing ' num2str(i) '/' num2str(length(files))])
    [ce_sz_bp_r(i),ce_sz_bp_p(i)] = corr(...
        [avl_sz{i}{:}]',[avl_bp{i}{:}]','Type','Spearman');
end
clear i
%% plot
figure(2)
clf
histogram(ce_sz_bp_r,10)
prettify
%%
figure(3)
clf
x = [];
y = [];
for i = 1 : length(avl_bp)
    x = [x avl_sz{i}{:}];
    y = [y avl_bp{i}{:}];
end
clear i
plot(x,y,'k.','MarkerSize',10)
prettify
%%
[ce_p,ce_r] = corr(x',y','Type','Spearman');
