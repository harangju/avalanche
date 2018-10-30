
%% load distributions
result_dir = '~/Developer/avalanche/paper figures/fig3_3_2cycle_seed1/20181029_105239';
% result_dir = '~/Developer/avalanche/paper figures/fig3_3_4cycle_seed1/20181026_153621';
% result_dir = '~/Developer/avalanche/paper figures/fig3_3_4cycle_seed2/20181029_104029';
subdirs = dir(result_dir);

durs = cell(1,length(subdirs)-2);
dur_max = zeros(1,length(subdirs)-2);
distr = zeros(1,length(subdirs)-2);
As = cell(1,length(subdirs)-2);
patses = cell(1,length(subdirs)-2);

for d = 3 : length(subdirs)
    load([result_dir '/' subdirs(d).name '/matlab.mat'])
    disp(subdirs(d).name)
    distr(d-2) = redistr;
    As{d-2} = A;
    dur_max(d-2) = dur;
    patses{d-2} = pats;
    durs{d-2} = avl_durations_cell(Y);
end

clearvars -except durs dur_max distr vars As order

%% calculate histogram counts

xs = cell(1,length(durs));
ys = cell(1,length(durs));

bin_count = 1e5;

for i = 1 : length(xs)
    [xs{i}, ys{i}] = hist_log10(durs{i}, bin_count);
end
clear bin_count

%% calculate - slope, intercepts of dur distr
slopes = zeros(1,length(xs));
y_int = zeros(1,length(xs));
x_int = zeros(1,length(xs));
pts = cell(1,length(xs));
% pts = 10:30;
for i = 1 : length(distr)
    pts{i} = floor(length(xs{i})/2) : length(xs{i})-1;
    f = polyfit(xs{i}(pts{i}), ys{i}(pts{i}), 1);
    slopes(i) = f(1);
    y_int(i) = f(2);
    x_int(i) = -1 * y_int(i)/slopes(i);
end
clear i f

%% plots - example distribution
idx_distr = 1 : 11 : length(xs)/2+1;
% idx_distr = 1 : 11 : length(xs)/2+1;
% colors = linspecer(length(idx_distr));
colors = [3.1, 18.8, 42;...
    2, 43.9, 69;...
%     45.5, 66.3, 81.2;...
    81.6, 82, 90.2] ./ 100;
plts = zeros(1,length(idx_distr));
lgnd = cell(1,length(idx_distr));
clf; hold on
for i = 1 : length(idx_distr)
    idx = idx_distr(i);
    scatter(xs{idx},ys{idx},36,'.','MarkerEdgeColor',colors(i,:))
    plts(i) = plot(xs{idx}(3:max(pts{idx})),...
        polyval([slopes(idx) y_int(idx)], xs{idx}(3:max(pts{idx}))),...
        'Color',colors(i,:));
    lgnd{i} = ['\Deltaw=' num2str(distr(idx))];
end
prettify
% axis([0 3.1 -5 0])
legend(plts,lgnd,'Location','Northeast')
clear idx_distr colors plts lgnd i idx
min
%% plots - delta w vs slopes
clf
scatter(distr,slopes,20,[3.1, 18.8, 42]./100,'filled')
prettify
% axis([-.1 1.1 -3 0])
hold on
f_dur = polyfit(distr,slopes,2);
plot(distr,polyval(f_dur,distr),'Color',[3.1 18.8 42]./100)

%% calculate - 


%% plots - example var
clf; hold on
idx_var = 1 : 3 : length(xs)/2;
colors = linspecer(length(idx_var));
lgnd = cell(1,length(idx_var));
for i = 1 : length(idx_var)
    idx = idx_var(i);
    plot(mean(vars{idx},1),'Color',colors(i,:))
    lgnd{i} = ['\Deltaw=' num2str(distr(idx))];
end
clear i idx idx_var
hold off
prettify
legend(lgnd,'Location','Northwest')

%% plots - delta w vs slopes var
scatter(distr, slopes_var, 20, [2 43.9 69]./100, 'filled')
prettify
axis([-.1 1.1 0 .3])
hold on
f_var = polyfit(distr,slopes_var,2);
plot(distr,polyval(f_var,distr),'Color',[2 43.9 69]./100)
disp([2 43.9 69]./100.*255)
