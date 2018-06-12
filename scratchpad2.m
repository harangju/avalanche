
%%
N = 100;
A = diag(rand(1,N)*0.9);
B = ones(N,1);
p.num_nodes = N;
imagesc(A); colorbar; prettify
%%
g = graph_from_matrix(A);
plot(g)

%% fig2.m
%% eigendecomposition
[v,d] = eig(A);
d = diag(d);
%% make inputs with eigenvectors real, positive, & integers
scale = 1;
pats = cell(1,p.num_nodes);
dups = 0;
for i = 1 : p.num_nodes
    pats{i} = v(:,i);
    if ~isreal(d(i))
        if i < p.num_nodes &&...
                abs(d(i)) == abs(d(i+1))
            pats{i} = v(:,i) + v(:,i+1);
        elseif abs(d(i)) == abs(d(i-1))
            pats{i} = v(:,i) + v(:,i-1);
            dups = dups + 1;
        end
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
beep
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


%%
thresh = 0.35;
clf; hold on
scatter(d(pat),duration,'.')
scatter(d,dur_mean,'filled','r')
lin = d.^(1:100)';
exp_dur = zeros(1,N);
for i = 1 : N
exp_dur(i) = find(lin(:,i)<thresh,1);
end
scatter(d,exp_dur,'g')
prettify; hold off
%%
[d'; dur_mean; exp_dur; d'.^dur_mean]

%%
t = 40;
clf; hold on
plot(d.^(0:t)','LineWidth',1.5)
plot(1:t,thresh*ones(1,t),'LineWidth',1.5)
hold off 
prettify

%%
scatter(d,d'.^dur_mean,'filled')
prettify

%%
n = 20;
t = 1:n/2;
clf; hold on
% read data
[c,e] = histcounts(duration(pat==n));
bar(mean([e(1:end-1)' e(2:end)'],2),c/sum(c))
% plot((0:t)'.*(1-d(100).^(0:t)'),'LineWidth',1.5)
dead = 1-d(n).^t';
plot(t,dead,'LineWidth',1.5)
% derivative
dead_pr = -2*d(n).^t'.*log(d(n));
plot(t,dead_pr,'LineWidth',1.5)
% derivative X duration
r = t' .* dead_pr;
plot(t,r,'LineWidth',1.5)
legend({'durations', 'fraction dead', 'fraction dying', ...
    'fraction w/ duration t'})
hold off; prettify

%%
sections = 0;
for i = 1 : N
    
end; clear i
