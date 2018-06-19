
%%
N = 50;
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
scale = 10;
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
%% add patterns together
% pats_dub = cell(size(pats));
% pats_dub{1} = pats{1};
% for i = 2 : length(pats)
%     pats_dub{i} = pats{i-1} + pats{i};
% end
%%
[d_real_sort, idx] = sort(d_real,'descend');
%% equal prob
dur = 100; iter = 3e4;
probs = ones(1,length(pats)) / length(pats);
tic
% [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
[Y,pat] = trigger_many_avalanches(A,B,pats_dub,probs,dur,iter);
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


%% plot distributions
thresh = 0.35;
clf; hold on
scatter(d(pat),duration,'.')
scatter(d,dur_mean,'filled','r')
lin = d.^(1:100)';
exp_dur = zeros(1,N);
for i = 1 : N
exp_dur(i) = find(lin(:,i)<thresh,1);
end
prettify; hold off

%% plot exp
t = 50;
clf; hold on
plot(d.^(0:t)','LineWidth',1.5)
plot(1:t,thresh*ones(1,t),'LineWidth',1.5)
hold off 
prettify

%% plot individual
n = 41;
t = 0:59;
clf; hold on
% read data
[c,e] = histcounts(duration(pat==n),length(t)-1);
bar(mean([e(1:end-1)' e(2:end)'],2),c/sum(c))
% plot((0:t)'.*(1-d(100).^(0:t)'),'LineWidth',1.5)
dead = (1-d(n).^t').^scale;
dead2 = (1-d(n-1).^t').^scale;
% dead = (1-d(n).^t').^scale .* (1-d(n-1).^t').^scale;
plot(t,dead,'LineWidth',1.5)
% derivative
% dead_frac = -1*d(n).^t(2:end)'.*log(d(n));
% dead_frac = -1*diff(d(n).^t');
% dead_frac = scale*(1-d(n).^t(2:end)).^(scale-1)...
%     .*-1.*d(n).^t(2:end).*log(d(n));
% dead_frac = diff(dead .* dead2);
dead_frac = diff(dead);
plot(t(2:end),dead_frac,'LineWidth',1.5)
legend({'simulated durations', 'fraction dead', 'fraction dying'},'Location',...
    'east')
hold off; prettify; title(['\lambda = ' num2str(d(n))])
sum(dead_frac' .* t(2:end))

%% predictions
pred = zeros(1,N);
t = 0:100;
for i = 1 : N
%     y = (1-d(i).^t).^scale .* (1-d(i-1).^t).^scale;
%     s = scale;
%     l1 = d(i);
%     l2 = d(i-1);
%     yp = (1-l1.^t).^s.*s.*(1-l2.^t).^(s-1).*-1.*l2.^t.*log(l2) ...
%         + (1-l2.^t).^s.*s.*(1-l1.^t).^(s-1).*-1.*l1.^t.*log(l1);
%     pred(i) = sum(yp .* t);
%     pred(i) = sum(scale .* (1-d(i).^t).^(scale-1) .* -1 .* d(i).^t .* ...
%         log(d(i)) .* t);
    dead = (1-d(i).^t').^scale;
    pred(i) = sum(diff(dead) .* t(2:end)');
end; clear i

%% plot predictions
hold on
scatter(d,pred,'g')
hold off


