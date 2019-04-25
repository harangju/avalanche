%% 4-cycle
A0 = [0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 0 0];
N = 4;
B = ones(N,1);
redistr = 0.1;
T = 1e4;
K = 1e4;
dws = 0.02 : 0.02 : 0.98;
seed = 4;
%% 2-cycle
A0 = [0 1; 1 0];
N = 2;
B = ones(N,1);
redistr = 0.1;
T = 1e4;
K = 1e4;
dws = 0.02 : 0.02 : 0.98;
seed = 4;
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
    [Ys{i}, orders{i}] = avl_smp_many(pats, probs, As{i}, T, K);
end; clear i; fprintf('\n')
%% durations
durs = avl_durations_cell(Ys);
dur_mean = cellfun(@(x) sum(x(x<T-1)),durs);
%% plot - individual
d = distr(1:round(length(distr)/4):round(length(distr)/2));
colors = linspecer(length(d));
figure(1)
clf
for i = 1 : length(d)
    idx = find(distr==d(i));
    x = unique(durs{idx});
    y = histcounts(durs{idx},[x max(x)+1]);
    loglog(x,y/sum(y),'.','Color',colors(i,:),'MarkerSize',10)
    hold on
%     loglog(x,eq_e(x,ft_pl(1,idx,1)))
end
prettify
legend({['\Delta w =' num2str(d(1))],...
    ['\Delta w =' num2str(d(2))],...
    ['\Delta w =' num2str(d(3))]})
clear i idx x y d
%% plot - dw vs mean dur
figure(3)
clf
% plot(distr,1./ft_pl(1,:,2),'.k')
colors = linspecer(2);
plot(distr,dur_mean,'.k','MarkerSize',10)
hold on
ft_dw = polyfit(distr,dur_mean,2);
plot(distr,polyval(ft_dw,distr),'Color',colors(2,:))
prettify
%% mean of eigenvalues
se = cellfun(@(x) mean(abs(eig(x))), As);
% ce_se = corr(se',1./ft_pl(1,:,2)','Type','Spearman');
[ce_se_r,ce_se_p] = corr(se',dur_mean','Type','Spearman');
%% plot - sum eig vs mean dur
figure(5)
% plot(se,1./ft_pl(1,:,2),'.k')
plot(se,dur_mean,'.k','MarkerSize',10)
prettify
