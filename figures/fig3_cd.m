%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig3_cd.mat'])
else
    % load empirical data
    disp('Load cascades...')
    cascades = load_cascades(emp_data_dir);
    csc_cnt = cellfun(@length,cascades);
    durs = cellfun(@csc_durations,cascades,'uniformoutput',0);
    disp('Find cyclic activity...(this takes a few minutes)')
    lps = cellfun(@find_cyclic_activity,cascades,'uniformoutput',0);
    % bar graph of loop counts
    lps_cnt_max = 4;
    lp_cnt = zeros(length(lps),lps_cnt_max);
    for i = 1 : length(lp_cnt)
        e = [1:lps_cnt_max lps_cnt_max+1 max([lps{i}{:}])];
        h = histcounts([lps{i}{:}], e);
        lp_cnt(i,:) = h(1:lps_cnt_max);
    end
    clear i e h
end
%% fig3c
figure
clf
i = 1;
lps_r = [lps{i}{:}];
x = 10.^(0:.05:max(lps_r));
loglog(x,histcounts(lps_r,[x max(x)+1]),'k.','MarkerSize',10)
prettify
xlabel('loop length (bin size)')
ylabel('counts')
clear i lps_r x
%% fig3d
figure
clf
h = bar(lp_cnt./csc_cnt,'stacked');
colors = linspecer(lps_cnt_max);
for i = 1 : lps_cnt_max
    h(i).FaceColor = colors(i,:);
end
prettify
xlim([0 26])
legend({'1-loop','2-loop','3-loop','4-loop'})
clear i e h
