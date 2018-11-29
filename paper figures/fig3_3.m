
% %% load distributions
% % result_dir = ['~/Developer/avalanche/paper figures/...'
% %     'fig3_3_2cycle_seed1/20181029_105239'];
% % result_dir = ['~/Developer/avalanche/paper figures/...'
% %     'fig3_3_4cycle_seed1/20181026_153621'];
% result_dir = ['~/Developer/avalanche/paper figures/'...
%     'fig3_3_4cycle_seed2/20181029_104029'];
% subdirs = dir(result_dir);
% durs = cell(1,length(subdirs)-2);
% dur_max = zeros(1,length(subdirs)-2);
% dws = zeros(1,length(subdirs)-2);
% As = cell(1,length(subdirs)-2);
% patses = cell(1,length(subdirs)-2);
% 
% for d = 3 : length(subdirs)
%     load([result_dir '/' subdirs(d).name '/matlab.mat'])
%     disp(subdirs(d).name)
%     dws(d-2) = redistr;
%     As{d-2} = A;
%     dur_max(d-2) = dur;
%     patses{d-2} = pats;
%     durs{d-2} = avl_durations_cell(Y);
% end
% 
% clearvars -except durs dur_max distr vars As order

%% parameters
A0 = [0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 0 0];
N = 4;
B = ones(N,1);
redistr = 0.1;
dur = 1e4;
iter = 1e4;
dws = 0.02 : 0.02 : 0.98;
seed = 5;
%% create network
As = cell(1,length(dws));
for i = 1 : length(dws)
    rng(seed)
    As{i} = A0;
    for n = 1 : N
        og = find(A0(n,:));
        As{i}(n,og) = A0(n,og) - dws(i);
        new = randperm(N,1);
        while new == og
            new = randperm(N,1);
        end
        As{i}(n,new) = dws(i);
    end; clear n
end; clear i
%% simulate
[pats, probs] = pings_single(N);
Ys = cell(1,length(dws));
orders = cell(1,length(dws));
disp(repmat('#',[1 length(dws)]))
for i = 1 : length(dws)
    fprintf('.')
    [Ys{i}, orders{i}] = avl_smp_many(pats, probs, As{i}, dur, iter);
end; clear i; fprintf('\n')

%% calculate durations
durs = cell(1,length(dws));
for i = 1 : length(dws)
    durs{i} = avl_durations_cell(Ys{i});
end
%% calculate durations
dur_mean = zeros(1,length(As));
for i = 1 : length(As)
    dur_mean(i) = mean(durs{i});
end; clear i

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
for i = 1 : length(dws)
    pts{i} = ceil(length(xs{i})/2) : length(xs{i})-1;
    f = polyfit(xs{i}(pts{i}), ys{i}(pts{i}), 1);
    slopes(i) = f(1);
    y_int(i) = f(2);
    x_int(i) = -1 * y_int(i)/slopes(i);
end
clear i f

%% plots - example distribution
% idx_distr = 1 : length(xs)/2;
% colors = linspecer(length(idx_distr));
idx_distr = 1 : 11 : length(xs)/2+1;
colors = [3.1, 18.8, 42;...
    2, 43.9, 69;...
%     45.5, 66.3, 81.2;...
    81.6, 82, 90.2] ./ 100;
plts = zeros(1,length(idx_distr));
lgnd = cell(1,length(idx_distr));
figure(1); clf; hold on
for i = 1 : length(idx_distr)
    idx = idx_distr(i);
    scatter(xs{idx},ys{idx},36,'.','MarkerEdgeColor',colors(i,:))
    plts(i) = plot(xs{idx}(3:max(pts{idx})),...
        polyval([slopes(idx) y_int(idx)], xs{idx}(3:max(pts{idx}))),...
        'Color',colors(i,:));
    lgnd{i} = ['\Deltaw=' num2str(dws(idx))];
end
prettify
axis([0 4 0 4])
legend(plts,lgnd,'Location','Northeast')
clear idx_distr colors plts lgnd i idx

%% plots - delta w vs slopes
figure(2); clf
scatter(dws,slopes,10,[3.1, 18.8, 42]./100,'filled')
prettify
hold on
f_dur = polyfit(dws,slopes,2);
plot(dws,polyval(f_dur,dws),'Color',[3.1 18.8 42]./100)
axis([-.1 1.1 -4 0])
% axis([-.1 1.1 -8 0])

%% calculate eigenvalues
ev_sum = zeros(1,length(dws));
for i = 1 : length(dws)
    ev_sum(i) = eig_sum(As{i}');
end; clear i

%% plot - eigenvalues vs slopes
figure(3); clf; hold on
scatter(ev_sum,slopes,10,[3.1, 18.8, 42]./100,'filled')
f = polyfit(ev_sum',slopes',1);
x = min(ev_sum):0.01:max(ev_sum);
plot(x,polyval(f,x),'Color',[3.1, 18.8, 42]./100);
disp(corr(ev_sum',slopes'))
% axis([.9 2.1 -7 -1])
% axis([.5 4.5 -6 0])
axis([1.8 4.2 -4 0])
hold off; prettify

%% plot network
figure(4); clf
imagesc(As{10}); prettify

