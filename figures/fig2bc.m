
%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig2bc.mat'])
else
    disp('Generating networks...')
    sn_b = {...
        net.generate('erdosrenyi','n',2^8,'p',.1,'dir',true),...
        net.generate('hiermodsmallworld','mx_lvl',8,'e',1.695,...
            'sz_cl',2),...
        net.generate('wattsstrogatz','n',2^8,'k',26,'p',.5,'dir',true),...
        net.generate('modular','n',2^8,'k',int32(2^16*.05),'m',4,...
            'p',0.8,'dir',true),...
        };
    sn_fc = cellfun(@(x) nnz(x.A)/size(x.A,1)^2, sn_b); % frac conn
    sn_tw = 2;
%     sn_sig = repmat(.04:.001:.048,[1 sn_tw]);
    sn_sig = repmat(.036:.001:.048,[1 sn_tw]);
    sn_w = cell(length(sn_b),length(sn_sig));
    for i = 1 : length(sn_b)
        for j = 1 : length(sn_sig)
            sn_w{i,j} = net.distr_weights(sn_b{i}.A,...
                'truncnorm','mu',0,'sigma',sn_sig(j),'range',[0 2]);
%             sn_w{i,j} = sn_b{i};
%             sn_w{i,j}.A = sn_sig(j) * ...
%                 (sn_w{i,j}.A ./ sum(sn_w{i,j}.A,2));
        end
    end
    sn_w = sn_w(:);
    clear i j
    disp('Calculating eigen measures...')
    eigmax = cellfun(@(x) max(abs(eig(x.A))), sn_w);
%     eigsum = cellfun(@(x) sum(abs(eig(x.A))), sn_w);
    disp('Simulating...(this takes a while)')
    disp(repmat('-',[1 4 0]))
    T = 1e3;
    K = 1e6;
    durs = cell(length(sn_w),1);
    for i = 1 : length(sn_w)
        fprintf(['\tnetwork ' num2str(i) '/' num2str(length(sn_w)) '\n'])
        [y0s,p_y0s] = pings_single(size(sn_w{i}.A,1));
        durs{i} = csc_durations(simulate(@smp,sn_w{i}.A,y0s,T,p_y0s,K));
    end
    clear y0s p_y0s i
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
    ft_pl_sim = table(...
        ft_pl(:,1),...
        1./ft_pl(:,2),...
        min(1./ft_pl(:,2),T),...
        ft_pl(:,3),...
        'VariableNames',{'Alpha','Tau','Tau_prime','Xmin'});
    clear ft_pl
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Calculating correlations...')
    idx = ~isinf(ft_pl_sim.Tau);
    ft_lin = table(...
        fit(eigmax(idx),ft_pl_sim.Alpha(idx),'poly1'),...
        fit(eigmax(idx),log10(ft_pl_sim.Tau_prime(idx)),'poly1'),...
        fit(eigmax(idx),log10(ft_pl_sim.Tau(idx)),'poly1'),...
        fit(eigmax(idx),ft_pl_sim.Xmin(idx),'poly1'),...
        fit(eigmax(idx),cellfun(@max,durs(idx)),'poly1'),...
        'VariableNames',{'Alpha','Tau_prime','Tau','Xmin','Dmax'});
    [r_sim_a,p_sim_a] = corr(eigmax(idx),ft_pl_sim.Alpha(idx));
    [r_sim_t,p_sim_t] = corr(eigmax(idx),ft_pl_sim.Tau(idx),...
        'Type','Spearman');
    [r_sim_tp,p_sim_tp] = corr(eigmax(idx),ft_pl_sim.Tau_prime(idx),...
        'Type','Spearman');
    [r_sim_xm,p_sim_xm] = corr(eigmax(idx),ft_pl_sim.Xmin(idx));
    [r_sim_dm,p_sim_dm] = corr(eigmax(idx),cellfun(@max,durs(idx)),...
        'Type','Spearman');
    ft_corr = table(...
            r_sim_a', p_sim_a',...
            r_sim_t', p_sim_t',...
            r_sim_tp', p_sim_tp',...
            r_sim_xm', p_sim_xm',...
            r_sim_dm', p_sim_dm',...
        'VariableNames',{...
            'r_alpha','p_alpha',...
            'r_tau','p_tau',...
            'r_tau_p','p_tau_p',...
            'r_xmin','p_xmin',...
            'r_dmax','p_dmax'});
    clear r_* p_* idx
    disp(ft_corr)
end
%% fig2b
% requires Symbolic Math Toolbox
figure
color = linspecer(1);
i = 79;
x = unique(durs{i});
y = histcounts(durs{i},[x T+1]) / length(durs{i});
clf
loglog(x,y,'k.','MarkerSize',12)
hold on
% function l = eq_l(x,a,t,xm)
%     l = eq_c(a,1./t,xm) .* eq_f(x,a,1./t,xm);
% end
eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
eq_l = @(x,a,t,xm) eq_c(a,1./t,xm) .* eq_f(x,a,1./t,xm);
y = eq_l(x,ft_pl_sim.Alpha(i),ft_pl_sim.Tau(i),ft_pl_sim.Xmin(i));
loglog(x,y./sum(y),'r-')
legend({'stochastic model','truncated power law'})
prettify
axis([0 max(x) 8e-7 1])
clear i x y eq_c eq_f eq_l
%% fig2c
figure
clf
semilogy(eigmax,ft_pl_sim.Tau_prime,'.','MarkerSize',10,'Color',color)
hold on
x1 = min(eigmax):1e-3:max(eigmax);
[ci1,y1] = predint(ft_lin.Tau_prime,x1,.95,'observation','off');
ci1 = 10.^ci1;
y1 = 10.^y1;
plot(x1,y1,'Color',color)
patch([x1 fliplr(x1)],[ci1(:,1)' fliplr(ci1(:,2)')],...
    color,'FaceAlpha',0.2,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x1 x2 ci1 ci2 y1 y2
%% display stats
disp(ft_corr)
disp(['Alpha = ' num2str(mean(ft_pl_sim.Alpha))...
    '+-' num2str(std(ft_pl_sim.Alpha)/sqrt(length(durs)))])
