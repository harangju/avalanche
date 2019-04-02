%% generate binary synthetic networks
sn_b = {...
    net.generate('erdosrenyi','n',2^8,'p',.08,'dir',true),...
    net.generate('erdosrenyi','n',2^8,'p',.1,'dir',true),...
    net.generate('erdosrenyi','n',2^8,'p',.115,'dir',true),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.8,'sz_cl',2),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.7,'sz_cl',2),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.65,'sz_cl',2),...
    net.generate('wattsstrogatz','n',2^8,'k',20,'p',.5,'dir',true),...
    net.generate('wattsstrogatz','n',2^8,'k',25,'p',.5,'dir',true),...
    net.generate('wattsstrogatz','n',2^8,'k',27,'p',.5,'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.04),'m',4,'p',0.8,...
        'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.05),'m',4,'p',0.8,...
        'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.055),'m',4,'p',0.8,...
        'dir',true),...
    };
sn_fc = zeros(1,length(sn_b));
for i = 1 : length(sn_b)
    sn_fc(i) = nnz(sn_b{i}.A)/size(sn_b{i}.A,1)^2;
end; clear i
%% distribute weights, delta + truncated gaussian
wd_sig = [.03 .04 .05];
sn_w = cell(length(sn_b),length(wd_sig));
for i = 1 : length(sn_b)
    for j = 1 : length(wd_sig)
        sn_w{i,j} = net.distr_weights(sn_b{i}.A,...
            'truncnorm','mu',0,'sigma',wd_sig(j),'range',[0 2]);
    end
end
%% check row col sums
cv_me = zeros(length(sn_b),length(wd_sig));
for i = 1 : length(sn_b)
    for j = 1 : length(wd_sig)
        cv_me(i,j) = max(eig(sn_w{i,j}.A));
    end
end
disp([0 1:length(wd_sig); (1:length(sn_b))' cv_me])
%% set parameters
av_T = 1e3;
av_K = 1e6;
%% simulate
% durs = cell(length(sn_b),length(wd_sig));
disp(repmat('-',[1 50]))
for i = 1% : length(sn_b)
    for j = 1% : length(wd_sig)
        disp(['Simulating topology ' num2str(i) '/' ...
            num2str(length(sn_b)) ' & sig=' num2str(wd_sig(j))])
        [x0,Px0] = pings_single(size(sn_w{i,j}.A,1));
        x = avl_smp_many(x0,Px0,sn_w{i,j}.A,av_T,av_K);
        durs{i,j} = avl_durations_cell(x);
        clear x
        save
    end
end; clear x0 Px0 x
 %% mle - power law with exponential cutoff
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_p = @(x,a,s) eq_c(a,1./s,1) .* eq_f(x,a,1./s,1);
%%
pl_p = zeros(length(sn_b),2,length(wd_sig));
pl_e = zeros(length(sn_b),length(wd_sig));
pl_g = zeros(length(sn_b),2,length(wd_sig));
pl_ci = zeros(2,2,length(sn_b),length(wd_sig));
%%
for i = 7 : length(sn_b)
    for j = 1 : length(wd_sig)
        disp(['Calculating MLE for topology ' num2str(i) '/'...
            num2str(length(sn_b)) ' & sig=' num2str(wd_sig(j))])
        [pl_p(i,:,j),pl_ci(:,:,i,j)] = mle(durs{i,j},'pdf',eq_p,...
            'start',[3 2],'LowerBound',[.1 1],'UpperBound',[20 av_T]);
%         pl_e(i,j) = mle(durs{i,j},'distribution','exp');
%         pl_g(i,:,j) = mle(durs{i,j},'distribution','gam');
    end
end; clear i j
%%
save
%% plot
for i = 1 : length(sn_b)
    for j = 1 : length(wd_sig)
        x = unique(durs{i,j});
        e = [x av_T+1];
        y = histcounts(durs{i,j},e) / length(durs{i,j});
%         x = 10.^(0:.1:log10(av_T));
%         e = [x av_T+1];
%         e = x;
%         y = histcounts(durs{i,j},e) ./ diff(e) / length(durs{i,j});
        ml_pl = eq_p(x,pl_p(i,1,j),pl_p(i,2,j));
%         ml_pl = eq_p(x,3,5);
        ml_ep = exppdf(x,pl_e(i,j));
        ml_g = gampdf(x,pl_g(i,1,j),pl_g(i,2,j));
        clf
        subplot(1,3,1); imagesc(sn_w{i,j}.A); prettify; colorbar
        title(sn_b{i}.topology)
        subplot(1,3,2); histogram(sn_w{i,j}.A(sn_w{i,j}.A>0)); prettify
        title(['weight distribution, \sigma=' num2str(wd_sig(j))])
        axis([0 0.3 0 1e3])
        subplot(1,3,3)
        loglog(x,y,'.'); hold on;
        loglog(x,ml_pl,'-');
%         loglog(x,ml_ep,'-')
%         loglog(x,ml_g,'-')
        prettify; title(['\alpha=' num2str(pl_p(i,1,j)) ...
            ', s=' num2str(num2str(pl_p(i,2,j)))])
        axis([0 av_T 10^-10 1])
%         saveas(gcf,['i=' num2str(i) ' j=' num2str(j) '.png'])
        pause
    end
end; clear x e y
%%
a=repmat(linspace(1,3,10),[10 1]);
s=repmat(linspace(1,100,10)',[1 10]);
for i = 1:.003:3
    surf(a,s,eq_p(i,a,s))
    set(gca,'ZScale','log')
    axis vis3d; prettify; axis([1 3 1 10 .1 1]); pause(0.03);
end
%%
clf; hold on; j=1:3;
c = linspecer(length(sn_b));
for i = 1 : length(sn_b)
%     scatter(reshape(pl_p(i,1,j),1,[]),reshape(pl_p(i,2,j),1,[]),...
%         100+1000*(sn_fc(i)-min(sn_fc))/range(sn_fc),c(i,:),'.')
    scatter(reshape(pl_p(i,1,j),1,[]),reshape(pl_p(i,2,j),1,[]),...
        100+1000*(wd_sig-min(wd_sig))/range(wd_sig),c(i,:),'.')
end
legend({},'Location','Northwest')
prettify