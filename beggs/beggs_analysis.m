
%%
load('te_matlab_0.5/Izhik_100_0.mat')
%%
jitter_size = 19;
jitter = @(x) jitter_size * (ones(size(x)) - 2*(rand(size(x)) < 0.5)) + x;
one_bound = @(x) max(1,x);
%% jitter
asdf_j = cellfun(jitter, asdf(1:end-2), 'un', false);
asdf_j = cellfun(one_bound, asdf_j, 'un', false);
asdf_j(end+1:end+2) = asdf(end-1:end);
%% transfer entropy
delays = 1:30;
tic; [te_pk, ci] = ASDFTE(asdf,delays); toc
tic; [te_pk_j, ci_j] = ASDFTE(asdf_j,delays); toc
%% create filter
filt_dim = [25 25];
filt_bounds = [-8 -2 0 1];
edge_te_pk = linspace(filt_bounds(1),filt_bounds(2),filt_dim(1)+1);
edge_ci = linspace(filt_bounds(3),filt_bounds(4),filt_dim(2)+1);
n_j = histcounts2(log10(te_pk_j(:)),  ci_j(:),...
    edge_te_pk, edge_ci);
n = histcounts2(log10(te_pk(:)),  ci(:),...
    edge_te_pk, edge_ci);
filt = n_j ./ (n + n_j);
filt(isnan(filt)) = 0;
%% filter
thresh = 0.1; %0.37;
filt_thr = 1 - (filt > thresh);
keep = zeros(size(ci));
for i = 1 : asdf{end}(1)
    for j = 1 : asdf{end}(1)
        idx_ci = find(edge_ci < ci(i,j), 1, 'last');
        idx_te_pk = find(edge_te_pk < log10(te_pk(i,j)), 1, 'last');
        if filt(idx_te_pk, idx_ci) < thresh
            keep(i,j) = 1;
        end
    end
end
clear i j
%% plot
figure(1)
subplot(2,2,1)
scatter(log10(te_pk(:)),ci(:),'.')
prettify; axis square; title('actual')
subplot(2,2,2)
scatter(log10(te_pk_j(:)),ci_j(:),'.')
prettify; axis square; title('jittered')
subplot(2,2,3)
scatter(log10(te_pk(keep>0)),ci(keep>0),'.')
prettify; axis square; title('separation');
axis([-8 -2 0 1])
subplot(2,2,4)
imagesc(filt_thr')
% imagesc(filt')
prettify; axis square; title('filter'); set(gca,'YDir','normal');
colormap gray; colorbar
subplot(2,2,4)
%%
bounds = 1:80;
c = conmat(bounds,bounds);
k = keep(bounds,bounds);
figure(2)
subplot(2,2,1)
imagesc(k)
prettify; axis square; colorbar; set(gca,'YDir','normal')
title('TE & CI')
subplot(2,2,2)
imagesc(c~=0)
prettify; axis square; colorbar; set(gca,'YDir','normal')
title('actual')
subplot(2,2,3)
imagesc((c~=0) & k)
prettify; axis square; colorbar; set(gca,'YDir','normal')
title('both')
tpr = sum(c(:)~=0 & k(:)) / sum(k(:)); % TPR=TP/P=TP/(TP+FN)
tnr = sum(c(:)==0 & ~k(:)) / sum(~k(:)); % TNR=TN/N=TN/(TN+FP)
fpr = sum(c(:)==0 & k(:)) / sum(~k(:)); % FPR=FP/N=FP/(FP+TN)=1-TNR
rt = tpr/fpr;
disp([tpr tnr (1-tnr) fpr rt tpr+tnr])
clear c k

