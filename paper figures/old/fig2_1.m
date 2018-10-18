
%% network
p = default_network_parameters;
p.N = 100; p.N_in = 100;
p.N = 10; p.N_in = 10;
p.frac_conn = 0.1;
p.frac_conn = 0.3;
p.graph_type = 'weightedrandom';
p.weighting = 'uniform'; p.weighting_params = 1;
p.critical_branching = true;
p.critical_convergence = true;
[A, B] = network_create(p);
% A = A * .9;
figure(1); imagesc(A); colorbar; prettify
%% view
figure(1)
imagesc(A)
colorbar
prettify
%% trigger_avalanches
dur = 1e3;
trials = 1e5;
[pats, probs] = pings_single(p.N);
tic
[Y,order] = avalanche_smp_many(pats,probs,A,dur,trials);
toc
%% fig 1a
figure(1)
n=12;
plot(sum(Y{n},1), 'k', 'LineWidth', .75)
prettify;
set(gca,'LineWidth',.75)
%% measure duration
duration = avl_durations_cell(Y);
%% check power law
[alpha,xmin] = plfit(duration);
figure(2)
plplot(duration,xmin,alpha); prettify


%%
n = 1;
Yn = Y(order==1);
[-1*diff(pa); histcounts(duration,(0:20)+0.5)]
% [x,y] = hist_log10(avl_durations_cell(Yn),100);
% [x,y] = histcounts(avl_durations_cell(Yn),(0:20)+.5);
% scatter(x,y,'.'); prettify
% pa = p_alive(pats{n},A,30);
% [x,y] = hist_log10(-1*diff(pa),100);
% hold on; 

%% mean duration
dur_mean = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_mean(i) = mean(duration(order==i));
end; clear i
%% predictor
H = zeros(length(pats),dur);
for i = 1 : length(pats)
    H(i,:) = p_alive(pats{i},A,dur);
end; clear i
H_m = mean(H.*(1:dur),2);
H_m(isnan(H_m)) = 0;
%% fig 2b
figure(2); clf
pat_ex = 4;
plot(H(pat_ex,:))
hold on
histogram(duration(order==pat_ex),30)
hold off
%% fig 2c
% plot individual durations
figure(3)
scatter(H_m,dur_mean,'.k')
prettify
%% linear fit
f = polyfit(H_m,dur_mean',1);
hold on
x = min(H_m):1e-2:max(H_m);
plot(x,polyval(f,x),'r')
hold off
%% pearson correlation
[r,p] = corr(H_m,dur_mean'); disp(r)



