
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
% if rank(A) ~= p.num_nodes
%     error('matrix not full rank')
% end
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
scale = 10;
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
else
    d_real = [];
    pats_no_dup = {};
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
dur = 100; iter = 3e4;
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc
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
    infl(i) = norm(diag(d)\v*pats{i}/scale);
%     bar(inv(v)*pats{i}/scale)
%     axis([0 p.num_nodes -1 1])
%     pause
end
%% duration as function of eigenvalues
% scatter(d_real,dur_mean,'filled','k')
scatter(infl,dur_mean,'filled','k')
% scatter(infl(dur_mean<100),dur_mean(dur_mean<100),'filled','k')
prettify;
set(gca,'LineWidth',.75)
%% correlation b/t eigenvalue & duration
% c = corrcoef([infl' dur_mean'],'Type','Pearson');
% c = corrcoef([infl' dur_mean']);
c = corrcoef([infl(dur_mean<100)' dur_mean(dur_mean<100)']);
disp(c)
%% linear regression
% [p] = polyfit(infl,dur_mean,1);
lin_reg = polyfit(infl(dur_mean<100),dur_mean(dur_mean<100),1);
hold on
% x = 0:1e-2:max(infl);
x = 0:1e-2:max(infl(dur_mean<100));
y = x*lin_reg(1) + lin_reg(2);
plot(x,y,'r','LineWidth',.75)
hold off
%% rmse of linear regression
rmse = sqrt(mean((dur_mean-infl*p(1)+p(2)).^2));
disp(['rmse = ' num2str(rmse)])
%% examples - average activity
ns = [1 15 30 45];
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
plot(mean(activity(1,:),1), 'k', 'LineWidth', .75)
prettify; %axis([0 30 0 20])
set(gca,'LineWidth',.75)
