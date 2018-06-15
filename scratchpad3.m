
%%
N = 10;
p = default_network_parameters;
p.num_nodes = 10;
p.num_nodes_input = 10;
p.num_nodes_output = 10;
p.frac_conn = 0.5;
[A,B,C] = network_create(p);
imagesc(A); colorbar; prettify
%%
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

%%
t = 50;
plot(scale*d.^(0:t)','LineWidth',1.5)
prettify


%% plot individual
n = 10;
t = 0:59;
clf; hold on
% read data
[c,e] = histcounts(duration(pat==n),length(t)-1);
bar(mean([e(1:end-1)' e(2:end)'],2),c/sum(c))
dead = (1-d(n).^t').^scale;
plot(t,dead,'LineWidth',1.5)
dead_frac = diff(dead .* dead2);
plot(t(2:end),dead_frac,'LineWidth',1.5)
legend({'durations', 'fraction dead', 'fraction dying'},'Location',...
    'east')
hold off; prettify
sum(dead_frac' .* t(2:end))



