
%% network
p = default_network_parameters;
p.num_nodes = 30;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.1;
% p.frac_conn = 0.1;
p.graph_type = 'RG';
p.exp_branching = 1;
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);
%%
[r,ri_c] = rref(A);
[r,ri_r] = rref(A');
imagesc(r); colorbar
disp(length(ri_c))
A = A(ri_r,ri_c);
disp(rank(A))
%%
p.num_nodes = length(ri_c);
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
A = scale_weights_to_criticality(A);
B = ones(p.num_nodes,1);
C = ones(p.num_nodes,1);
%% view
imagesc(A)
colorbar
prettify
%% eigendecomposition
[v,d] = eig(A);
d = diag(d);
[~,idx] = sort(d);
%% check connectivity
disp(mean(A(:)>0))
%%
imagesc(A)
prettify; axis square; colorbar
%%
dur = 1e3; iter = 1e3;
%% 
input_activity = 0.1;
pats = cell(1,iter);
for i = 1 : iter
    pats{i} = rand(p.num_nodes,1) < input_activity;
end
%% simulation
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%%
activity = squeeze(sum(Y,1))';
%% measure duration
duration = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        duration(i) = find(activity(i,:)>0,1,'last');
    else
        duration(i) = 0;
    end
end; clear i
%% mean duration
dur_mean = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_mean(i) = mean(duration(pat==i));
end
%% calculate eigen-thing
infl = zeros(1,length(pats));
for i = 1 : length(pats)
    infl(i) = norm(diag(d)*(v\pats{i}));
end
%% duration as function of eigenvalues
% scatter(d_real,dur_mean,'filled','k')
% scatter(d_real,log(dur_mean),'filled','k')
scatter(infl,dur_mean,'filled','k')
% scatter(infl(dur_mean<100),dur_mean(dur_mean<100),'filled','k')
prettify
set(gca,'LineWidth',.75)
%% plot individual durations
scatter(infl,duration,'.')
prettify
%% correlation b/t eigenvalue & duration
% c = corrcoef([infl' dur_mean'],'Type','Pearson');
c = corrcoef([infl' dur_mean']);
% c = corrcoef([infl(dur_mean<100)' dur_mean(dur_mean<100)']);
disp(c)
%% linear regression
% [p] = polyfit(infl,dur_mean,1);
lin_reg = polyfit(infl,dur_mean,1);
hold on
% x = 0:1e-2:max(infl);
x = 0:1e-2:max(infl);
y = x*lin_reg(1) + lin_reg(2);
plot(x,y,'r','LineWidth',.75)
hold off
%% rmse of linear regression
rmse = sqrt(mean((dur_mean-infl*f(1)+f(2)).^2));
disp(['rmse = ' num2str(rmse)])
%% examples - average activity
ns = [1 6 11 16 21 26];
lineStyles = linspecer(length(ns));
clf; hold on
plts = [];
for i = 1 : length(ns)
    color = i;
    act_p = activity(pat==idx(ns(i)),:);
    act_m = mean(act_p, 1);
    act_se = std(act_p, 0, 1) / sqrt(size(act_p,1));
    act_s = std(act_p, 0, 1);
    act_v = var(act_p, 0, 1);
    plts = [plts plot(act_m, 'Color', lineStyles(i,:), 'LineWidth', .75)];
    error_shade(1:dur, act_m, act_se, lineStyles(i,:), 'LineWidth', .75);
end; clear i; hold off
prettify
legend(plts, {...
    ['\lambda=' num2str(d_real_sort(ns(1)))],...
    ['\lambda=' num2str(d_real_sort(ns(2)))],...
    ['\lambda=' num2str(d_real_sort(ns(3)))],...
    ['\lambda=' num2str(d_real_sort(ns(4)))],...
    ['\lambda=' num2str(d_real_sort(ns(5)))],...
    ['\lambda=' num2str(d_real_sort(ns(6)))]});
set(gca,'LineWidth',.75)
%% example avalanche
plot(mean(activity(2,:),1), 'k', 'LineWidth', .75)
prettify; %axis([0 30 0 20])
set(gca,'LineWidth',.75)
