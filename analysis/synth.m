%% generate binary synthetic networks
sn_b = {...
    net.generate('erdosrenyi','n',2^8,'p',.06,'dir',true),...
    net.generate('erdosrenyi','n',2^8,'p',.1,'dir',true),...
    net.generate('erdosrenyi','n',2^8,'p',.14,'dir',true),...
    net.generate('erdosrenyi','n',2^8,'p',.18,'dir',true),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.9,'sz_cl',2),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.7,'sz_cl',2),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.6,'sz_cl',2),...
    net.generate('hiermodsmallworld','mx_lvl',8,'e',1.55,'sz_cl',2),...
    net.generate('wattsstrogatz','n',2^8,'k',16,'p',.5,'dir',true),...
    net.generate('wattsstrogatz','n',2^8,'k',26,'p',.5,'dir',true),...
    net.generate('wattsstrogatz','n',2^8,'k',34,'p',.5,'dir',true),...
    net.generate('wattsstrogatz','n',2^8,'k',42,'p',.5,'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.03),'m',4,'p',0.8,...
        'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.05),'m',4,'p',0.8,...
        'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.07),'m',4,'p',0.8,...
        'dir',true),...
    net.generate('modular','n',2^8,'k',int32(2^16*.09),'m',4,'p',0.8,...
        'dir',true),...
    };
sn_fc = zeros(length(sn_b),1);
for i = 1 : length(sn_b)
    sn_fc(i) = nnz(sn_b{i}.A)/size(sn_b{i}.A,1)^2;
end; clear i
%% set weight parameters
sn_tw = 4;
sn_sig = repmat(.03:.01:.05,[1 sn_tw]);
%% distribute weights (delta + truncated gaussian)
sn_w = cell(length(sn_b),length(sn_sig));
for i = 1 : length(sn_b)
    for j = 1 : length(sn_sig)
        sn_w{i,j} = net.distr_weights(sn_b{i}.A,...
            'truncnorm','mu',0,'sigma',sn_sig(j),'range',[0 2]);
    end
end; clear i j
cv_me = zeros(length(sn_b),length(sn_sig));
cv_se = zeros(length(sn_b),length(sn_sig));
for i = 1 : length(sn_b)
    for j = 1 : length(sn_sig)
        l = eig(sn_w{i,j}.A);
        cv_me(i,j) = max(l);
        cv_se(i,j) = sum(abs(l));
    end
end; clear i j l
% disp([0 1:length(sn_sig); (1:length(sn_b))' cv_me])
%% set parameters
av_T = 1e3;
av_K = 1e6;
%% simulate
durs = cell(length(sn_b),length(sn_sig));
av_ef = zeros(length(sn_b),length(sn_sig));
disp(repmat('-',[1 50]))
for i = 1:length(sn_b)
    for j = 1:length(sn_sig)
        disp(['Simulating topology ' num2str(i) '/'...
            num2str(length(sn_b)) ' & weights ' num2str(j) '/'...
            num2str(length(sn_sig))])
        [x0,Px0] = pings_single(size(sn_w{i,j}.A,1));
        av = avl_smp_many(x0,Px0,sn_w{i,j}.A,av_T,av_K);
        durs{i,j} = avl_durations_cell(av);
        av_mt = (durs{i,j}==av_T-1);
        av_end = reshape(cell2mat(av(av_mt)),...
            [size(sn_w{i,j}.A,1) sum(av_mt) av_T]);
        av_ef(i,j) = sum(sum(av_end(:,:,end),1)==size(av_end,1))/size(av_end,2);
        clear av av_mt av_end
%         save
    end
end; clear x0 Px0 av
sendmail('wngkfkd94@gmail.com','network analysis done')
 %% mle - power law with exponential cutoff
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_p = @(x,a,s) eq_c(a,1./s,1) .* eq_f(x,a,1./s,1);
eq_l = @(x,a,l) eq_c(a,l,1) .* eq_f(x,a,l,1);
%%
pl_p = zeros(length(sn_b),length(sn_sig),2);
pl_e = zeros(length(sn_b),length(sn_sig));
pl_g = zeros(length(sn_b),length(sn_sig),2);
pl_ci = zeros(length(sn_b),length(sn_sig),2,2);
%%
for i = 1:length(sn_b)
    for j = 1:length(sn_sig)
        disp(['Calculating MLE for topology ' num2str(i) '/'...
            num2str(length(sn_b)) ' & weights ' num2str(j) '/'...
            num2str(length(sn_sig))])
        [pl_p(i,j,:),pl_ci(i,j,:,:)] = mle(durs{i,j},'pdf',eq_p,...
            'start',[3 2],'LowerBound',[.1 1],'UpperBound',[20 av_T]);
        pl_e(i,j) = mle(durs{i,j},'distribution','exp');
        pl_g(i,j,:) = mle(durs{i,j},'distribution','gam');
    end
end; clear i j
%% individual plots
for i = 10 %1:length(sn_b)
    for j = 5 %1:length(sn_sig)
        x = unique(durs{i,j});
%         x = 10.^(0:.1:log10(av_T));
        e = [x av_T+1];
        y = histcounts(durs{i,j},e) / length(durs{i,j});
        ml_tpl = eq_l(x,ft_pl_sim(i,j,1),ft_pl_sim(i,j,2));
        clf
        loglog(x,y,'.','Color',color,'MarkerSize',10); hold on
        loglog(x,ml_tpl,'r-')
        legend({'stochastic model','truncated power law'})
        prettify
        axis([0 av_T 3e-5 1])
%         saveas(gcf,['i=' num2str(i) ' j=' num2str(j) '.png'])
%         pause
    end
end; clear x e y ml_tpl
%% scatter plot
% i=(1:4)+12;
i=1:length(sn_b);
j=1:length(sn_sig);
pl_a = reshape(pl_dp(i,j,1),1,[]);
pl_d = 1./reshape(pl_dp(i,j,2),1,[]);
cv_m = reshape(cv_me(i,j),1,[]);
cv_s = reshape(cv_se(i,j),1,[]);
sn_s = repmat(sn_sig(j),[1 length(i)]);
sn_f = repmat(sn_fc(i)',[1 length(j)]);
% pl_a = pl_a(cv_m<1);
% pl_d = pl_d(cv_m<1);
% sn_s = sn_s(cv_m<1);
% sn_f = sn_f(cv_m<1);
% cv_s = cv_s(cv_m<1);
% cv_m = cv_m(cv_m<1);
% structure
figure(1); clf
subplot(2,1,1)
scatter(pl_a,pl_d,100,sn_s,'s')
ylabel(colorbar,'\sigma')
prettify; colormap winter
xlabel('\alpha'); ylabel('\tau')
subplot(2,1,2)
scatter(pl_a,pl_d,100,sn_f,'s')
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
% structure
figure(4); clf
subplot(2,2,1)
scatter(sn_s,pl_d,'.')
prettify; xlabel('\sigma'); ylabel('\tau')
subplot(2,2,2)
scatter(sn_f,pl_d,'.')
prettify; xlabel('density'); ylabel('\tau')
subplot(2,2,3)
scatter(sn_s,pl_a,'.')
prettify; xlabel('\sigma'); ylabel('\alpha')
subplot(2,2,4)
scatter(sn_f,pl_a,'.')
prettify; xlabel('density'); ylabel('\alpha')
clear i j

%% paper figures - synth1 - lambda<1
color = [3.1, 18.8, 42]/100;
%% network
cv_m = abs(cv_me(:));
cv_s = cv_se(:);
%% sim
ft_pl_a_sim = ft_pl_sim(:,:,1);
ft_pl_a_sim = ft_pl_a_sim(:);
ft_pl_t_sim = 1./ft_pl_sim(:,:,2);
ft_pl_t_sim = ft_pl_t_sim(:);
durs_sim_max = cellfun(@max,durs(:));
ft_pl_t_sim(ft_pl_t_sim>durs_sim_max) = ...
    durs_sim_max(ft_pl_t_sim>durs_sim_max);
ft_t_sim1 = fit(cv_m(cv_m<1),log10(ft_pl_t_sim(cv_m<1)),'poly1');
ft_a_sim1 = fit(cv_m(cv_m<1&cv_m>.8),ft_pl_a_sim(cv_m<1&cv_m>.8),'poly1');
[ce_r_t_sim1,ce_p_t_sim1] = corr(cv_m(cv_m<1),...
    ft_pl_t_sim(cv_m<1),'Type','Spearman');
[ce_r_t_sim1,ce_p_t_sim1] = corr(cv_m(cv_m<1),...
    log10(ft_pl_t_sim(cv_m<1)),'Type','Spearman');
[ce_r_a_sim1,ce_p_a_sim1] = corr(cv_m(cv_m<1&cv_m>.8),...
    ft_pl_a_sim(cv_m<1&cv_m>.8),'Type','Spearman');
%% simulation - tau
figure(1)
clf
semilogy(cv_m(cv_m<1),ft_pl_t_sim(cv_m<1),'.','MarkerSize',10,...
    'Color',color)
hold on
x1 = min(cv_m(cv_m<1)):1e-3:max(cv_m(cv_m<1));
[ci1,y1] = predint(ft_t_sim1,x1,.95,'observation','off');
ci1 = 10.^ci1;
y1 = 10.^y1;
plot(x1,y1,'Color',color)
patch([x1 fliplr(x1)],[ci1(:,1)' fliplr(ci1(:,2)')],...
    color,'FaceAlpha',0.2,'LineStyle','none')
prettify
% xlabel('\lambda_1')
% ylabel('\tau')
% axis([.45 1.05 1 1000])
clear x1 x2 ci1 ci2 y1 y2
%% simulation - alpha
figure(2)
clf
plot(cv_m(cv_m<1),ft_pl_a_sim(cv_m<1),'.','MarkerSize',10,'Color',color)
hold on
x1 = min(cv_m(cv_m<1&cv_m>.8)):1e-3:max(cv_m(cv_m<1&cv_m>.8));
[ci1,y1] = predint(ft_a_sim1,x1,.95,'observation','off');
plot(x1,y1,'Color',color)
patch([x1 fliplr(x1)],[ci1(:,1)' fliplr(ci1(:,2)')],...
    color,'FaceAlpha',0.15,'LineStyle','none')
prettify
% xlabel('\lambda_1')
% ylabel('\tau')
% axis([.45 1.05 1 1000])
clear x1 x2 ci1 ci2 y1 y2

%% paper figures - synth2 - lambda<1 & lambda>1
%% network
cv_m = abs(cv_me(:));
cv_s = cv_se(:);
%% sim
ft_pl_a_sim = ft_pl_sim(:,:,1);
ft_pl_a_sim = ft_pl_a_sim(:);
ft_pl_t_sim = 1./ft_pl_sim(:,:,2);
ft_pl_t_sim = ft_pl_t_sim(:);
durs_sim_max = cellfun(@max,durs_sim(:));
ft_pl_t_sim(ft_pl_t_sim>durs_sim_max) = ...
    durs_sim_max(ft_pl_t_sim>durs_sim_max);
ft_t_sim1 = fit(cv_m(cv_m<1),log10(ft_pl_t_sim(cv_m<1)),'poly1');
ft_a_sim1 = fit(cv_m(cv_m<1),ft_pl_a_sim(cv_m<1),'poly1');
[ce_r_t_sim1,ce_p_t_sim1] = corr(cv_m(cv_m<1),log10(ft_pl_t_sim(cv_m<1)));
[ce_r_a_sim1,ce_p_a_sim1] = corr(cv_m(cv_m<1),ft_pl_a_sim(cv_m<1));
ft_t_sim2 = fit(cv_m(cv_m>1),log10(ft_pl_t_sim(cv_m>1)),'poly1');
ft_a_sim2 = fit(cv_m(cv_m>1),ft_pl_a_sim(cv_m>1),'poly1');
[ce_r_t_sim2,ce_p_t_sim2] = corr(cv_m(cv_m>1),log10(ft_pl_t_sim(cv_m>1)));
[ce_r_a_sim2,ce_p_a_sim2] = corr(cv_m(cv_m>1),ft_pl_a_sim(cv_m>1));
%% simulation - tau
figure(1)
clf
semilogy(cv_m,ft_pl_t_sim,'k.','MarkerSize',10)
hold on
x1 = min(cv_m(cv_m<1)):1e-3:max(cv_m(cv_m<1));
x2 = min(cv_m(cv_m>1)):1e-3:max(cv_m(cv_m>1));
[ci1,y1] = predint(ft_t_sim1,x1,.95,'observation','off');
[ci2,y2] = predint(ft_t_sim2,x2,.95,'observation','off');
ci1 = 10.^ci1;
ci2 = 10.^ci2;
y1 = 10.^y1;
y2 = 10.^y2;
plot(x1,y1,'k')
plot(x2,y2,'k')
patch([x1 x2 fliplr([x1 x2])],...
    [ci1(:,1)' ci2(:,1)' fliplr([ci1(:,2)' ci2(:,2)'])],...
    'black','FaceAlpha',0.15,'LineStyle','none')
prettify
% xlabel('\lambda_1')
% ylabel('\tau')
% axis([.45 1.05 1 1000])
clear x1 x2 ci1 ci2 y1 y2
%% simulation - alpha
figure(2)
clf
plot(cv_m,ft_pl_a_sim,'k.','MarkerSize',10)
hold on
x1 = min(cv_m(cv_m<1)):1e-3:max(cv_m(cv_m<1));
x2 = min(cv_m(cv_m>1)):1e-3:max(cv_m(cv_m>1));
[ci1,y1] = predint(ft_a_sim1,x1,.95,'observation','off');
[ci2,y2] = predint(ft_a_sim2,x2,.95,'observation','off');
plot(x1,y1,'k')
plot(x2,y2,'k')
patch([x1 x2 fliplr([x1 x2])],...
    [ci1(:,1)' ci2(:,1)' fliplr([ci1(:,2)' ci2(:,2)'])],...
    'black','FaceAlpha',0.15,'LineStyle','none')
prettify
% xlabel('\lambda_1')
% ylabel('\tau')
% axis([.45 1.05 1 1000])
clear x1 x2 ci1 ci2 y1 y2
