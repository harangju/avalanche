
%%
% n = net.generate('topology','hiermodsmallworld',...
%     'mx_lvl',14,...
%     'e',1.3,...
%     'sz_cl',4); % 10% connectivity
n = net.generate('topology','hiermodsmallworld',...
    'mx_lvl',10,...
    'e',1.7,...
    'sz_cl',4); % 10% connectivity
imagesc(n.A./sum(n.A)); colorbar; prettify
%% generative
load +net/+imported/demo_generative_models_data
n = net.generate('topology','generativegrowth',...
    'seed',Aseed,...
    'd',D,...
    'm',nnz(Apos)/2,...
    'modeltype','neighbors',...
    'modelvar',[{'powerlaw'},{'powerlaw'}],...
    'params',[-2,0.2; -5,1.2; -1,1.5]); % 10% connectivity
%%
n = net.generate('topology','weightedrandom',...
    'n',1024,...
    'p',0.1,...
    'directed',true);
%%
n = net.generate('topology','random',...
    'n',1024,...
    'k',int32(.1*1024^2),...
    'directed',true);
%%
bin_size = 1;
load 'beggs data'/'DataSet1.mat'
n = net.generate('topology','autoregressive',...
    'v',spike_times_to_bins(data.spikes,bin_size)',...
    'pmin',1, 'pmax',6);
%%
figure(4); clf
p = size(n.A,2)/size(n.A,1);
for i = 1 : p
    subplot(3,3,i)
    imagesc(n.A(:,(1:98)+98*(i-1))); colorbar; prettify
end; clear i
colormap(brewermap([],'YlGnBu'))
%%
A = sum(reshape(n.A,[size(n.A,1) size(n.A,1) p]),3);
% A = n.A;
figure(1); imagesc(A); colorbar; prettify
colormap(brewermap([],'YlGnBu'))
% colormap parula
%% run avalanches
[pats, probs] = pings_single(size(n.A,1));
% [X,order] = avl_smp_many(pats,probs,(n.A./sum(n.A,2))',3e4,1e4);
% [X,order] = avl_smp_many(pats,probs,(n.A./sum(n.A,2))',1e3,1e4);
% n.Apos = A .* (A>0);
% [X,order] = avl_smp_many(pats,probs,A,1e3,1e4);
[X,order] = avl_smp_many(pats,probs,A',1e3,1e6);
% [X,order] = avl_smp_many(pats,probs,A./sum(A,1),1e3,1e4);
%% power law dynamics
dsim = avl_durations_cell(X);
%% data
ddata = avl_durations_cell(detect_avalanches(spike_times_to_bins(...
    data.spikes,bin_size)));
%% plot
[alpha_d,xmin_d,L_d] = plfit(ddata);
figure(2); plplot(ddata,xmin,alpha_d); prettify
title('data'); xlabel('duration'); ylabel('Pr(duration)')
%%
[alpha_s,xmin_s,L_s] = plfit(dsim);
figure(3); plplot(dsim,xmin,alpha_s); prettify
title('sim'); xlabel('duration'); ylabel('Pr(duration)')
%% KL - calc probs
calcp = @(x,y) sum(y == x') / length(x); % x,y row vectors
pdata = calcp(ddata, union(unique(ddata),unique(dsim)));
psim = calcp(dsim, union(unique(ddata),unique(dsim)));
kl = @(p,q) sum( p(p>0&q>0) .* log2(p(p>0&q>0)./q(p>0&q>0)) );
kld = kl(psim, pdata);




%%
load 'beggs data'/'DataSet4.mat'
%%
bin_size = 2;
aval = detect_avalanches(spike_times_to_bins(data.spikes,bin_size));
dur = avl_durations_cell(aval);
%%
for i = find(dur>50)
    imagesc(aval{i})
    pause
end; clear i

