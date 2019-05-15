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
% set weight parameters
sn_tw = 4;
sn_sig = repmat(.03:.01:.05,[1 sn_tw]);
% distribute weights (delta + truncated gaussian)
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
%% simulate
av_T = 1e3;
av_K = 1e6;
durs = cell(length(sn_b),length(sn_sig));
av_ef = zeros(length(sn_b),length(sn_sig));
disp(repmat('-',[1 50]))
av_act = cell(length(sn_b),length(sn_sig));
for i = 1:length(sn_b)
    for j = 1:length(sn_sig)
        disp(['Simulating topology ' num2str(i) '/'...
            num2str(length(sn_b)) ' & weights ' num2str(j) '/'...
            num2str(length(sn_sig))])
        [x0,Px0] = pings_single(size(sn_w{i,j}.A,1));
        av = avl_smp_many(x0,Px0,sn_w{i,j}.A,av_T,av_K);
        av_act{i,j} = sum([av{:}]);
        durs{i,j} = avl_durations_cell(av);
        av_mt = (durs{i,j}==av_T-1);
        av_end = reshape(cell2mat(av(av_mt)),...
            [size(sn_w{i,j}.A,1) sum(av_mt) av_T]);
        av_ef(i,j) = sum(sum(av_end(:,:,end),1)==size(av_end,1))/size(av_end,2);
        clear av av_mt av_end
    end
end; clear x0 Px0 av
%% mle - power law with exponential cutoff
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_p = @(x,a,s) eq_c(a,1./s,1) .* eq_f(x,a,1./s,1);
eq_l = @(x,a,l) eq_c(a,l,1) .* eq_f(x,a,l,1);
%% fig2d
i = 10;
j = 5;
x = unique(durs{i,j});
e = [x av_T+1];
y = histcounts(durs{i,j},e) / length(durs{i,j});
ml_tpl = eq_l(x,ft_pl_sim(i,j,1),ft_pl_sim(i,j,2));
clf
loglog(x,y,'.','Color',color,'MarkerSize',10); hold on
loglog(x,ml_tpl,'r-')
legend({'stochastic model','truncated power law'})
prettify
axis([0 av_T 3e-5 1])
clear x e y ml_tpl i j
%% colors
color = linspecer(1);
%% network measures
cv_m = abs(cv_me(:));
cv_s = cv_se(:);
%% find correlations
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
[ce_r_a_sim1,ce_p_a_sim1] = corr(cv_m(cv_m<1&cv_m>.8),...
    ft_pl_a_sim(cv_m<1&cv_m>.8));
%% fig2e
figure
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
%% fig2f
figure
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

