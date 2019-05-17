%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig2_def.mat'])
else
    disp('Generating networks...')
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
        net.generate('modular','n',2^8,'k',int32(2^16*.03),'m',4,...
        'p',0.8,'dir',true),...
        net.generate('modular','n',2^8,'k',int32(2^16*.05),'m',4,...
        'p',0.8,'dir',true),...
        net.generate('modular','n',2^8,'k',int32(2^16*.07),'m',4,...
        'p',0.8,'dir',true),...
        net.generate('modular','n',2^8,'k',int32(2^16*.09),'m',4,...
        'p',0.8,'dir',true),...
        };
    sn_fc = cellfun(@(x) nnz(x.A)/size(x.A,1)^2, sn_b); % frac conn
    sn_tw = 4;
    sn_sig = repmat(.03:.01:.05,[1 sn_tw]);
    sn_w = cell(length(sn_b),length(sn_sig));
    for i = 1 : length(sn_b)
        for j = 1 : length(sn_sig)
            sn_w{i,j} = net.distr_weights(sn_b{i}.A,...
                'truncnorm','mu',0,'sigma',sn_sig(j),'range',[0 2]);
        end
    end
    clear i j
    disp('Calculating eigen measures...')
    eigmax = cellfun(@(x) max(abs(eig(x.A))), sn_w);
    eigsum = cellfun(@(x) sum(abs(eig(x.A))), sn_w);
    disp('Simulating...(this takes a while)')
    disp(repmat('-',[1 4 0]))
    T = 1e3;
    K = 1e6;
    cascades = cell(length(sn_b),length(sn_sig));
    for i = 1:length(sn_b)
        for j = 1:length(sn_sig)
            fprintf(['\ttopology ' num2str(i) '/'...
                num2str(length(sn_b)) ' & weights ' num2str(j) '/'...
                num2str(length(sn_sig)) '\n'])
            [y0s,p_y0s] = pings_single(size(sn_w{i,j}.A,1));
            cascades{i,j} = simulate(@smp,sn_w{i,j}.A,y0s,T,p_y0s,K);
        end
    end
    clear y0s p_y0s i j
    disp('Calculating durations...')
    durs = cellfun(@csc_durations,cascades,'uniformoutput',0);
    save('durs','durs','T')
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Calculating correlations...')
    eigmax_vec = eigmax(:);
    eigsum_vec = eigsum(:);
    ft_pl_a = ft_pl(:,:,1);
    ft_pl_a = ft_pl_a(:);
    ft_pl_t = 1./ft_pl(:,:,2);
    ft_pl_t = ft_pl_t(:);
    durs_sim_max = cellfun(@max,durs(:));
    ft_pl_t(ft_pl_t>durs_sim_max) = ...
        durs_sim_max(ft_pl_t>durs_sim_max);
    ft_t = fit(eigmax_vec(eigmax_vec<1),...
        log10(ft_pl_t(eigmax_vec<1)),'poly1');
    ft_a = fit(eigmax_vec(eigmax_vec<1&eigmax_vec>.8),...
        ft_pl_a(eigmax_vec<1&eigmax_vec>.8),'poly1');
    [r_t_sim,p_t_sim] = corr(eigmax_vec(eigmax_vec<1),...
        ft_pl_t(eigmax_vec<1),'Type','Spearman');
    [r_a_sim,p_a_sim] = corr(eigmax_vec(eigmax_vec<1&eigmax_vec>.8),...
        ft_pl_a(eigmax_vec<1&eigmax_vec>.8));
end
%% fig2d
color = linspecer(1);
i = 10;
j = 5;
x = unique(durs{i,j});
e = [x T+1];
y = histcounts(durs{i,j},e) / length(durs{i,j});
clf
loglog(x,y,'.','Color',color,'MarkerSize',10)
hold on
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_l = @(x,a,l) eq_c(a,l,1) .* eq_f(x,a,l,1);
y = eq_l(x,ft_pl(i,j,1),ft_pl(i,j,2));
loglog(x,y,'r-')
legend({'stochastic model','truncated power law'})
prettify
axis([0 T 3e-5 1])
clear i j x e y eq_c eq_f eq_l
%% fig2e
figure
clf
semilogy(eigmax_vec(eigmax_vec<1),ft_pl_t(eigmax_vec<1),'.',...
    'MarkerSize',10,'Color',color)
hold on
x1 = min(eigmax_vec(eigmax_vec<1)):1e-3:max(eigmax_vec(eigmax_vec<1));
[ci1,y1] = predint(ft_t,x1,.95,'observation','off');
ci1 = 10.^ci1;
y1 = 10.^y1;
plot(x1,y1,'Color',color)
patch([x1 fliplr(x1)],[ci1(:,1)' fliplr(ci1(:,2)')],...
    color,'FaceAlpha',0.2,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x1 x2 ci1 ci2 y1 y2
%% fig2f
figure
clf
plot(eigmax_vec(eigmax_vec<1),ft_pl_a(eigmax_vec<1),'.',...
    'MarkerSize',10,'Color',color)
hold on
x1 = min(eigmax_vec(eigmax_vec<1&eigmax_vec>.8)) : 1e-3 :...
    max(eigmax_vec(eigmax_vec<1&eigmax_vec>.8));
[ci1,y1] = predint(ft_a,x1,.95,'observation','off');
plot(x1,y1,'Color',color)
patch([x1 fliplr(x1)],[ci1(:,1)' fliplr(ci1(:,2)')],...
    color,'FaceAlpha',0.15,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x1 x2 ci1 ci2 y1 y2

