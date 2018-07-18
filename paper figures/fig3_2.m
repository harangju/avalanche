
%% load distributions
result_dir = 'avalanche/paper data/20180717_140743';
% result_dir = 'avalanche/paper data/20180718_130604';
subdirs = dir(result_dir);

xs = cell(1,length(subdirs)-2);
ys = cell(1,length(subdirs)-2);
distr = zeros(1,length(subdirs)-2);
vars = cell(1,length(subdirs)-2);

for d = 3 : length(subdirs)
    load([result_dir '/' subdirs(d).name '/matlab.mat'])
    % duration
    activity = squeeze(sum(Y,1))';
    durations = zeros(1,iter);
    for j = 1 : iter
        if sum(activity(j,:)) > 0
            durations(j) = find(activity(j,:)>0,1,'last');
        else
            durations(j) = 0;
        end
    end
    [c_d,e_d,bin_idx] = histcounts(durations,100);
    x = log10(e_d(2:end));
    y = log10(c_d/sum(c_d));
    x(isinf(y)) = [];
    y(isinf(y)) = [];
    xs{d-2} = x; ys{d-2} = y;
    distr(d-2) = redistr;
    % variance
    v = zeros(size(Y,1), dur);
    for t = 1 : dur
        v(:,t) = var(Y(:,t,:),0,3);
    end
    vars{d-2} = v;
end

clearvars -except xs ys distr vars

%% calculate - slope, intercepts of dur distr
slopes = zeros(1,length(xs));
y_int = zeros(1,length(xs));
x_int = zeros(1,length(xs));
pts = 3:15;
for i = 1 : length(distr)
    f = polyfit(xs{i}(pts), ys{i}(pts), 1);
    slopes(i) = f(1);
    y_int(i) = f(2);
    x_int(i) = -1 * y_int(i)/slopes(i);
end
clear i f

%% plots - example distribution
idx_distr = 1 : 7 : length(xs)/2+1;
colors = linspecer(length(idx_distr));
plts = zeros(1,length(idx_distr));
lgnd = cell(1,length(idx_distr));
clf; hold on
for i = 1 : length(idx_distr)
    idx = idx_distr(i);
    scatter(xs{idx},ys{idx},36,'.','MarkerEdgeColor',colors(i,:))
    plts(i) = plot(xs{idx},...
        polyval([slopes(idx) y_int(idx)],xs{idx}),'Color',colors(i,:));
    lgnd{i} = ['\Deltaw=' num2str(distr(idx))];
end
prettify
% axis([0 3.1 -5 0])
legend(plts,lgnd,'Location','Southwest')
clear idx_distr colors plts lgnd i idx

%% plots - delta w vs slopes
scatter(distr,slopes,'filled')
prettify
axis([-.1 1.1 -3 0])

%% calculate - slope of var
slopes_var = zeros(1,length(xs));
for i = 1 : length(vars)
    f = polyfit(1:size(vars{i},2), mean(vars{i},1), 1);
    slopes_var(i) = f(1);
end
clear i f

%% plots - example var
clf; hold on
idx_var = 1 : 7 : length(xs)/2;
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
scatter(distr, slopes_var, 'filled')
prettify
axis([-.1 1.1 0 .3])

