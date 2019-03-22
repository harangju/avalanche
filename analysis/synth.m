%%
sn = {...
    net.generate('random','n',1e2,'k',1e2,'directed',true),...
    net.generate('random','n',1e3,'k',1e3,'directed',true),...
    net.generate('erdosrenyi','n',1e2,'p',.001,'directed',true),...
    net.generate('erdosrenyi','n',1e3,'p',.001,'directed',true)...
    };
%%
sn_nt = length(sn);
durs = cell(1,sn_nt);
av_T = 1e3;
av_K = 3e4;
%% simulate
for i = 1 : sn_nt
    disp(['Simulating network ' num2str(i) ' out of ' num2str(sn_nt)])
    [x0,Px0] = pings_single(size(sn{i}.A,1));
    x = avl_smp_many(x0,Px0,sn{i}.A./(sum(sn{i}.A,2)+.01),av_T,av_K);
    durs{i} = avl_durations_cell(x);
end; clear i x0 Px0 x
%% power law with cutoff pdf
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_p = @(x,a,s) eq_c(a,1/s,1) .* eq_f(x,a,1/s,1);
%% mle
pl_p = zeros(sn_nt,2);
pl_ci = zeros(2,2,sn_nt);
for i = 1 : sn_nt
    [pl_p(i,:),pl_ci(:,:,i)] = mle(durs{i},'pdf',eq_p,'start',[1.5 10],... 
        'LowerBound',[.1 1],'UpperBound',[10 1e6]);
end; clear i
%% plot
for i = 1 : sn_nt
    x = unique(durs{i});
    y = histcounts(durs{i},[x av_T])/length(durs{i});
    subplot(2,1,1); imagesc(sn{i}.A); prettify
    subplot(2,1,2); clf; loglog(x,y,'.'); hold on;
    loglog(x,eq_p(x,pl_p(i,1),pl_p(i,2))); prettify; pause
end; clear i x y
