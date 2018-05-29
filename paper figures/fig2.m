
%% network
p = default_network_parameters;
p.num_nodes = 100;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.01;
p.graph_type = 'WRG';
p.exp_branching = 1;
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);
%% view
imagesc(A)
colorbar
prettify
%%
%% eigendecomposition
[v,d] = eig(A);
d = diag(d);
[~,idx] = sort(d);
%% check connectivity
disp(mean(A(:)>0))
%%
imagesc(A)
prettify; axis square; colorbar
%% eigenvalues
bar(d); prettify
%% dominant eigenvector
bar(v(:,1)); prettify
%% make inputs with eigenvectors real, positive, & integers
scale = 5;
pats = cell(1,p.num_nodes);
dups = 0;
% d_real = [];
for i = 1 : p.num_nodes
    pats{i} = v(:,i);
    if ~isreal(d(i))
        if i < p.num_nodes &&...
                abs(d(i)) == abs(d(i+1))
            pats{i} = v(:,i) + v(:,i+1);
        elseif abs(d(i)) == abs(d(i-1))
            pats{i} = v(:,i) + v(:,i-1);
            dups = dups + 1;
%             d_real = [d_real d(i)+d(i-1)];
        end
    else
%         d_real = [d_real d(i)];
    end
    if find(pats{i}<0); pats{i} = -1 * pats{i}; end
    pats{i}(pats{i}<0) = 0;
    pats{i} = abs(pats{i});
    pats{i} = round(scale * pats{i});
end; clear i
%% remove duplicates
if sum(abs(pats{1} - pats{2})) > 1e-10
    d_real = d(1);
    pats_no_dup = pats(1);
end
for i = 2 : length(pats)
    if sum(abs(pats{i-1} - pats{i})) > 1e-10
        pats_no_dup = [pats_no_dup pats{i}];
        d_real = [d_real abs(d(i))];
    end
end; clear i
pats = pats_no_dup;
%%
[d_real_sort, idx] = sort(d_real,'descend');
%% equal prob
dur = 60; iter = 1e4;
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc
%%
activity = squeeze(sum(Y,1))';
%% measure persistence
persistence = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        persistence(i) = find(activity(i,:)>0,1,'last');
    else
        persistence(i) = 0;
    end
end; clear i
%% mean persistence
pers_mean = zeros(1,length(pats));
for p = 1 : length(pats)
    pers_mean(p) = mean(persistence(pat==p));
end
%% persistence as function of eigenvalues
scatter(d_real,pers_mean,'filled','k')
prettify;
set(gca,'LineWidth',.75)
%% correlation b/t eigenvalue & persistence
c = corrcoef([d_real' pers_mean'],'Type','Pearson');
disp(c)
%% linear regression
[p] = polyfit(d_real,pers_mean,1);
hold on
x = 0:1e-2:max(d_real);
y = x*p(1) + p(2);
plot(x,y,'r','LineWidth',.75)
hold off
%% rmse of linear regression
rmse = sqrt(mean((pers_mean-d_real*p(1)+p(2)).^2));
disp(['rmse = ' num2str(rmse)])
%% examples - average activity
ns = [1 3 5 7 8 9];
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
plot(mean(activity(28,:),1), 'k', 'LineWidth', .75)
prettify; %axis([0 30 0 20])
set(gca,'LineWidth',.75)
