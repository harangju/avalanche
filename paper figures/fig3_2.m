
%% load distributions
result_dir = 'avalanche/paper figures/20180717_140743';
subdirs = dir(result_dir);

xs = cell(1,length(subdirs)-2);
ys = cell(1,length(subdirs)-2);
distr = zeros(1,length(subdirs)-2);

for d = 3 : length(subdirs)
    load([result_dir '/' subdirs(d).name '/matlab.mat'])
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
end

clearvars -except xs ys distr

%%
slopes = zeros(1,length(xs));
idx = 3:10;
clf
for i = 1 : length(xs)
    f = polyfit(xs{i}(idx), ys{i}(idx), 1);
    slopes(i) = f(1);
    scatter(xs{i},ys{i},'.'); prettify; hold on
    plot(xs{i},polyval(f,xs{i}))
%     hold off; drawnow
    axis([0 3.1 -5 0])
    hold off; pause
end
clear i f

%%
scatter(distr,slopes,'filled')
prettify

