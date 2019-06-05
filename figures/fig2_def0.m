%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig2_def.mat'])
else
    disp('Generating networks...')
    sn_b = {...
        net.generate('erdosrenyi','n',2^8,'p',.1,'dir',true),...
        };
    sn_fc = cellfun(@(x) nnz(x.A)/size(x.A,1)^2, sn_b); % frac conn
%     sn_tw = 4;
%     sn_sig = repmat(.03:.01:.05,[1 sn_tw]);
    sn_tw = 1;
    sn_sig = repmat(.98:.002:1,[1 sn_tw]);
    sn_w = cell(length(sn_b),length(sn_sig));
    for i = 1 : length(sn_b)
        for j = 1 : length(sn_sig)
%             sn_w{i,j} = net.distr_weights(sn_b{i}.A,...
%                 'truncnorm','mu',0,'sigma',sn_sig(j),'range',[0 2]);
            sn_w{i,j} = sn_b{i};
            sn_w{i,j}.A = sn_sig(i) * (sn_w{i,j}.A ./ sum(sn_w{i,j}.A,2));
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
%     cascades = cell(length(sn_b),length(sn_sig));
    durs = cell(length(sn_b),length(sn_sig));
    for i = 1:length(sn_b)
        for j = 1:length(sn_sig)
            fprintf(['\ttopology ' num2str(i) '/'...
                num2str(length(sn_b)) ' & weights ' num2str(j) '/'...
                num2str(length(sn_sig)) '\n'])
            [y0s,p_y0s] = pings_single(size(sn_w{i,j}.A,1));
%             cascades{i,j} = simulate(@smp,sn_w{i,j}.A,y0s,T,p_y0s,K);
            durs{i,j} = ...
                csc_durations(simulate(@smp,sn_w{i,j}.A,y0s,T,p_y0s,K));
        end
    end
    clear y0s p_y0s i j
    durs_max = T;
    save('durs','durs','durs_max')
    clear durs_max
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Loading power law fits...')
    load('ft_pl.mat')
    ft_pl = squeeze(ft_pl);
    ft_pl_sim = table(ft_pl(:,1),...
        1./ft_pl(:,2),...
        min(1./ft_pl(:,2),T),...
        ft_pl(:,3),...
        'VariableNames',{'Alpha','Tau','Tau_prime','Xmin'},...
        'RowNames',arrayfun(@num2str,1:length(ft_pl),'un',0));
    clear ft_pl
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Calculating correlations...')
    ft_lin = table(...
        fit(eigmax',ft_pl_sim.Alpha,'poly1'),...
        fit(eigmax',log10(ft_pl_sim.Tau_prime),'poly1'),...
        fit(eigmax',log10(ft_pl_sim.Tau),'poly1'),...
        'VariableNames',{'Alpha','Tau_prime','Tau'});
%     eigmax_vec = eigmax(:);
%     eigsum_vec = eigsum(:);
%     ft_t = fit(eigmax_vec(eigmax_vec<1),...
%         log10(ft_pl_t(eigmax_vec<1)),'poly1');
%     ft_a = fit(eigmax_vec(eigmax_vec<1&eigmax_vec>.8),...
%         ft_pl_a(eigmax_vec<1&eigmax_vec>.8),'poly1');
    [r_sim_a,p_sim_a] = corr(eigmax(eigmax<1 & eigmax>.8),...
        ft_pl_sim.Alpha(eigmax<1 & eigmax>.8));
    [r_sim_tp,p_sim_tp] = corr(eigmax(eigmax<1),...
        ft_pl_sim.Tau_prime(eigmax<1),'Type','Spearman');
%     [r_sim_a,p_sim_a] = corr(eigmax_vec(eigmax_vec<1&eigmax_vec>.8),...
%         ft_pl_a(eigmax_vec<1&eigmax_vec>.8));
%     [r_sim_t,p_sim_t] = corr(eigmax_vec(eigmax_vec<1),...
%         ft_pl_t(eigmax_vec<1),'Type','Spearman');
    ft_corr = table(...
            r_sim_a', p_sim_a',...
            r_sim_tp', p_sim_tp',...
        'VariableNames',{...
            'r_alpha','p_alpha',...
            'r_tau_p','p_tau_p'});
    clear r_* p_*
    disp(ft_corr)
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

