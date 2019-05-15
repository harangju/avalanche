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
A0 = [0 1; 1 0] * .99;
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
end
clear i og new
%% simulate
[y0s, p_y0s] = pings_single(N);
Ys = cell(1,length(dws));
i_y0s = cell(1,length(dws));
disp(repmat('#',[1 length(dws)]))
for i = 1 : length(dws)
    fprintf('.')
    [Ys{i}, i_y0s{i}] = simulate(model,A,y0s,T,p_y0s,K);
end; clear i; fprintf('\n')
%% durations
durs = cellfun(@avl_durations_cell,Ys,'uniformoutput',0);
dur_mean = cellfun(@(x) mean(x),durs);
%% fig3f,j
figure
d = dws(1:round(length(dws)/4):round(length(dws)/2));
colors = linspecer(length(d));
figure(1)
clf
for i = 1 : length(d)
    idx = find(dws==d(i));
    x = unique(durs{idx});
    y = histcounts(durs{idx},[x max(x)+1]);
    loglog(x,y/sum(y),'.','Color',colors(i,:),'MarkerSize',10)
    hold on
end
prettify
legend({['\Delta w =' num2str(d(1))],...
    ['\Delta w =' num2str(d(2))],...
    ['\Delta w =' num2str(d(3))]})
clear i idx x y d
%% fig3g,k
figure
colors = linspecer(2);
plot(dws,dur_mean,'.k','MarkerSize',10)
hold on
ft_dw = polyfit(dws,dur_mean,2);
plot(dws,polyval(ft_dw,dws),'Color',colors(2,:))
prettify
%% fig3h,l
se = cellfun(@(x) mean(abs(eig(x))), As);
[ce_se_r,ce_se_p] = corr(se',dur_mean','Type','Spearman');
figure
plot(se,dur_mean,'.k','MarkerSize',10)
prettify
