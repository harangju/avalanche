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
cv_se = zeros(length(sn_b),length(wd_sig));
for i = 1 : length(sn_b)
    for j = 1 : length(wd_sig)
        l = eig(sn_w{i,j}.A);
        cv_me(i,j) = max(l);
        cv_se(i,j) = sum(abs(l));
    end
end; clear i j l
disp([0 1:length(wd_sig); (1:length(sn_b))' cv_me])
%% set parameters
av_T = 1e3;
av_K = 1e6;
%% simulate
durs = cell(length(sn_b),length(wd_sig));
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
eq_l = @(x,a,l) eq_c(a,l,1) .* eq_f(x,a,l,1);
%%
pl_p = zeros(length(sn_b),length(wd_sig),2);
pl_e = zeros(length(sn_b),length(wd_sig));
pl_g = zeros(length(sn_b),length(wd_sig),2);
pl_ci = zeros(length(sn_b),length(wd_sig),2,2);
%%
for i = 7 : length(sn_b)
    for j = 1 : length(wd_sig)
        disp(['Calculating MLE for topology ' num2str(i) '/'...
            num2str(length(sn_b)) ' & sig=' num2str(wd_sig(j))])
        [pl_p(i,j,:),pl_ci(i,j,:,:)] = mle(durs{i,j},'pdf',eq_p,...
            'start',[3 2],'LowerBound',[.1 1],'UpperBound',[20 av_T]);
        pl_e(i,j) = mle(durs{i,j},'distribution','exp');
        pl_g(i,j,:) = mle(durs{i,j},'distribution','gam');
    end
end; clear i j
%%
save
%% plot
for i = 1 : length(sn_b)
    for j = 1 : length(wd_sig)
        x = unique(durs{i,j});
%         x = 10.^(0:.1:log10(av_T));
        e = [x av_T+1];
        y = histcounts(durs{i,j},e) / length(durs{i,j});
%         y = histcounts(durs{i,j},e) ./ diff(e) / length(durs{i,j});
        ml_pl = eq_p(x,pl_p(i,j,1),pl_p(i,j,2));
        ml_dpl = eq_l(x,pl_dp(i,j,1),pl_dp(i,j,2));
        ml_ep = exppdf(x,pl_e(i,j));
        ml_g = gampdf(x,pl_g(i,j,1),pl_g(i,j,2));
        clf
%         subplot(1,3,1); imagesc(sn_w{i,j}.A); prettify; colorbar
%         title(sn_b{i}.topology)
%         subplot(1,3,2); histogram(sn_w{i,j}.A(sn_w{i,j}.A>0)); prettify
%         title(['weights, \sigma=' num2str(wd_sig(j))])
%         axis([0 0.3 0 1e3])
%         subplot(1,3,3)
        loglog(x,y,'s'); hold on
        loglog(x,ml_pl,'-')
        loglog(x,ml_dpl,'-')
        loglog(x,ml_ep,'-')
        loglog(x,ml_g,'-')
        legend({'data',...
            ['PL (' num2str(pl_p(i,j,1),3) ','...
                num2str(pl_p(i,j,2),3) ')'],...
            ['DPL (' num2str(pl_dp(i,j,1),3) ','...
                num2str(pl_dp(i,j,2),3) ')'],...
            ['exp (' num2str(pl_e(i,j),3) ')'],...
            ['\gamma (' num2str(pl_g(i,j,1),3) ','...
                num2str(pl_g(i,j,2),3) ')']})
        prettify
        axis([0 av_T 1e-8 1])
        saveas(gcf,['i=' num2str(i) ' j=' num2str(j) '.png'])
%         pause
    end
end; clear x e y ml_pl ml_dpl ml_ep ml_g
%% scatter plot
i=1:length(sn_b);
j=1:length(wd_sig);
pl_a = reshape(pl_dp(i,j,1),1,[]);
pl_d = 1./reshape(pl_dp(i,j,2),1,[]);
cv_m = reshape(cv_me(i,j),1,[]);
cv_s = reshape(cv_se(i,j),1,[]);
% pl_d(pl_d==Inf) = 0;
% pl_d(pl_d>av_T) = av_T;
% pl_d(cv_me(:)>1) = av_T;
% structure
figure(1); clf
subplot(2,1,1)
scatter(pl_a,pl_d,100,repelem(wd_sig,1,length(i)),'s')
ylabel(colorbar,'\sigma')
prettify; colormap winter
xlabel('\alpha'); ylabel('\tau')
subplot(2,1,2)
scatter(pl_a,pl_d,100,repmat(sn_fc(i),1,length(j)),'s')
ylabel(colorbar,'density')
prettify; colormap winter
xlabel('\alpha'); ylabel('\tau')
% eigenvalues
figure(2); clf
subplot(2,2,1)
scatter(cv_m,pl_d,'.')
prettify; xlabel('\lambda_{max}'); ylabel('\tau')
subplot(2,2,2)
scatter(cv_s,pl_d,'.')
prettify; xlabel('\Sigma\lambda'); ylabel('\tau')
subplot(2,2,3)
scatter(cv_m,pl_a,'.')
prettify; xlabel('\lambda_{max}'); ylabel('\alpha')
subplot(2,2,4)
scatter(cv_s,pl_a,'.')
prettify; xlabel('\Sigma\lambda'); ylabel('\alpha')
% max & sum eigenvalue as color
figure(3)
clf
subplot(2,1,1)
scatter(pl_a,pl_d,100,cv_m,'s')
prettify; xlabel('\alpha'); ylabel('\tau')
colorbar; colormap('winter'); ylabel(colorbar, '\lambda_{max}')
subplot(2,1,2)
scatter(pl_a,pl_d,100,cv_s,'s')
prettify; xlabel('\alpha'); ylabel('\tau')
colorbar; colormap('winter'); ylabel(colorbar, '\Sigma\lambda')
