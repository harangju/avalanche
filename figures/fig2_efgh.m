%% try loading pre-generated data
% NOTE: If generating from scratch, run each section individually
if exist('source_data_dir','var')
    load([source_data_dir '/fig2_efgh.mat'])
else
    disp('Load cascades...')
    dur_emp = cellfun(@csc_durations,load_cascades(emp_data_dir),'un',0);
    nets = load_emp_nets(emp_data_dir);
    disp('Calculating eigen measures...')
    eigmax = cellfun(@(x) max(abs(eig(x.A))), nets);
    eigsum = cellfun(@(x) sum(abs(eig(x.A))), nets);
    eigavg = cellfun(@(x) mean(real(eig(x.A))), nets);
    disp('Simulating...')
    T = 1e3;
    K = 1e6;
    dur_sim = cell(1,length(nets));
    for i = 1 : length(nets)
        fprintf(['\tnetwork: ' num2str(i) '/' num2str(length(nets)) '\n'])
        [y0s,p_y0s] = pings_single(size(nets{i}.A,1));
        dur_sim{i} = csc_durations(simulate(@smp,nets{i}.A,y0s,T,p_y0s,K));
    end
    dur_avg = cellfun(@mean,dur_sim);
    clear i y0s p_y0s
    disp('Saving simulated durations')
    durs = dur_sim;
    durs_max = T;
    save('durs','durs','durs_max')
    clear durs durs_max
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Loading power law fits...')
    load('ft_pl.mat')
    ft_pl = squeeze(ft_pl);
    ft_pl_sim = table(...
        ft_pl(:,1), 1./ft_pl(:,2), min(1./ft_pl(:,2),T), ft_pl(:,3),...
        'VariableNames',{'Alpha','Tau','Tau_prime','Xmin'},...
        'RowNames',arrayfun(@num2str,1:length(ft_pl),'un',0));
    clear ft_pl
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Saving empirical durations')
    durs = dur_emp;
    durs_max = max(cellfun(@max,dur_emp))+1;
    save('durs','durs','durs_max')
    clear durs durs_max
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
end
%% continuing... 
if exist('source_data_dir','var') ~= 1
    disp('Loading power law fits...')
    load('ft_pl.mat')
    ft_pl_emp = table(...
        ft_pl(:,1), 1./ft_pl(:,2),...
        min(1./ft_pl(:,2),cellfun(@max,dur_emp)), ft_pl(:,3),...
        'VariableNames',{'Alpha','Tau','Tau_prime','Xmin'},...
        'RowNames',arrayfun(@num2str,1:length(ft_pl),'un',0));
    ft_cmp_emp = table(...
        'VariableNames',{'R','p'});
    clear ft_pl
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Calculating correlations...')
    ft_lin = table(...
        {fit(eigmax,ft_pl_sim.Alpha,'poly1');...
        fit(eigmax,ft_pl_emp.Alpha,'poly1')},...
        {fit(eigmax,log10(ft_pl_sim.Tau_prime),'poly1');...
        fit(eigmax,log10(ft_pl_emp.Tau_prime),'poly1')},...
        'VariableNames',{'Alpha','Tau_prime'},...
        'RowNames',{'simulated','empirical'});
    [r_a_sim,p_a_sim] = corr(eigmax,ft_pl_sim.Alpha);
    [r_a_emp,p_a_emp] = corr(eigmax,ft_pl_emp.Alpha);
    [r_t_sim,p_t_sim] = corr(eigmax,ft_pl_sim.Tau,...
        'Type','Spearman');
    [r_t_emp,p_t_emp] = corr(eigmax,ft_pl_emp.Tau,...
        'Type','Spearman');
    [r_tp_sim,p_tp_sim] = corr(eigmax,ft_pl_sim.Tau_prime,...
        'Type','Spearman');
    [r_tp_emp,p_tp_emp] = corr(eigmax,ft_pl_emp.Tau_prime,...
        'Type','Spearman');
    [r_md_sim,p_md_sim] = corr(eigmax,cellfun(@max,dur_sim),...
        'Type','Spearman');
    [r_md_emp,p_md_emp] = corr(eigmax,cellfun(@max,dur_emp),...
        'Type','Spearman');
    ft_corr = table(...
            [r_a_sim r_a_emp]', [p_a_sim p_a_emp]',...
            [r_t_sim r_t_emp]', [p_t_sim p_t_emp]',...
            [r_tp_sim r_tp_emp]', [p_tp_sim p_tp_emp]',...
            [r_md_sim r_md_emp]', [p_md_sim p_md_emp]',...
        'VariableNames',{...
            'r_alpha','p_alpha',...
            'r_tau','p_tau',...
            'r_tau_p','p_tau_p',...
            'r_dmax','p_dmax'},...
        'RowNames',{'simulated','empirical'});
    clear r_* p_*
    disp(ft_corr)
end
%% fig2e empirical
% figure
color = linspecer(2);
semilogy(eigmax,ft_pl_sim.Tau_prime,'.','MarkerSize',10,'Color',color(2,:))
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_lin.Tau_prime{1},x,.95,'functional','off');
ci = 10.^ci;
y = 10.^y;
plot(x,y,'Color',color(2,:))
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],color(2,:),...
    'FaceAlpha',0.1,'LineStyle','none')
hold off
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x ci y
%% fig2f empirical
figure
plot(eigmax,ft_pl_sim.Alpha,'.','MarkerSize',10,'Color',color(2,:))
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_lin.Alpha{1},x,.95,'functional','off');
ci(ci<=0) = 0;
y(y<=0) = 0;
plot(x,y,'Color',color(2,:))
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],color(2,:),...
    'FaceAlpha',0.1,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\alpha')
clear x ci y
%% fig2g
figure
clf
semilogy(eigmax,ft_pl_emp.Tau_prime,'.','MarkerSize',10,'Color',color(2,:))
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_lin.Tau_prime{2},x,.95,'functional','on');
ci = 10.^ci;
y = 10.^y;
plot(x,y,'Color',color(2,:))
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
    color(2,:),'FaceAlpha',0.15, 'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x ci y
%% fig2h
figure
clf
plot(eigmax,ft_pl_emp.Alpha,'.','MarkerSize',10,'Color',color(2,:))
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_lin.Alpha{2},x,.95,'functional','on');
ci(ci<=0) = 0;
y(y<=0) = 0;
plot(x,y,'Color',color(2,:))
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
    color(2,:),'FaceAlpha',0.15,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\alpha')
clear x ci y color





% %%
% subplot(2,1,1)
% plot(dur_avg,ft_pl_emp.Alpha,'k.','MarkerSize',10)
% prettify
% xlabel('\lambda_1')
% ylabel('\alpha')
% title(['r=' num2str(ft_corr.r_alpha(2)) ...
%     '; p=' num2str(ft_corr.p_alpha(2))])
% clear x ci y color
% subplot(2,1,2)
% semilogy(dur_avg,ft_pl_emp.Tau_prime,'k.','MarkerSize',10)
% prettify
% xlabel('\lambda_1')
% ylabel('\tau')
% title(['r=' num2str(ft_corr.r_tau(2)) ...
%     '; p=' num2str(ft_corr.p_tau(2))])
% clear x ci y
% %%
% [~,idx] = sort(eigmax);
% for i = idx
%     clf
%     
%     subplot(2,4,1)
%     hold on
%     plot(eigmax,ft_pl_emp.Alpha,'k.','MarkerSize',10)
%     plot(eigmax(i),ft_pl_emp.Alpha(i),'xr')
%     x = min(eigmax):1e-3:max(eigmax);
%     [ci,y] = predint(ft_lin.Alpha{2},x,.95,'functional','on');
%     ci(ci<=0) = 0;
%     y(y<=0) = 0;
%     plot(x,y,'g')
%     patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
%         'g','FaceAlpha',0.15,'LineStyle','none')
%     prettify
%     xlabel('\lambda_1')
%     ylabel('\alpha')
%     title(['emp r=' num2str(ft_corr.r_alpha(2)) ...
%         '; p=' num2str(ft_corr.p_alpha(2))])
%     clear x ci y color
%     
%     subplot(2,4,2)
%     semilogy(eigmax,ft_pl_emp.Tau_prime,'k.','MarkerSize',10)
%     hold on
%     plot(eigmax(i),ft_pl_emp.Tau_prime(i),'xr')
%     x = min(eigmax):1e-3:max(eigmax);
%     [ci,y] = predint(ft_lin.Tau_prime{2},x,.95,'functional','on');
%     ci = 10.^ci;
%     y = 10.^y;
%     plot(x,y,'g')
%     patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
%         'g','FaceAlpha',0.15, 'LineStyle','none')
%     prettify
%     xlabel('\lambda_1')
%     ylabel('\tau')
%     title(['emp r=' num2str(ft_corr.r_tau_p(2)) ...
%         '; p=' num2str(ft_corr.p_tau_p(2))])
%     clear x ci y
%     
%     subplot(2,4,3)
%     hold on
% %     plot(eigmax,ft_pl_sim.Alpha,'k.','MarkerSize',10)
% %     plot(eigmax(i),ft_pl_sim.Alpha(i),'xr')
% %     x = min(eigmax):1e-3:max(eigmax);
%     plot(eigmax_plus,ft_pl_sim.Alpha,'k.','MarkerSize',10)
%     plot(eigmax_plus(i),ft_pl_sim.Alpha(i),'xr')
%     x = min(eigmax_plus):1e-3:max(eigmax_plus);
%     [ci,y] = predint(ft_lin.Alpha{1},x,.95,'functional','on');
%     ci(ci<=0) = 0;
%     y(y<=0) = 0;
%     plot(x,y,'g')
%     patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
%         'g','FaceAlpha',0.15,'LineStyle','none')
%     prettify
%     xlabel('\lambda_1')
%     ylabel('\alpha')
%     title(['sim r=' num2str(ft_corr.r_alpha(1)) ...
%         'p=' num2str(ft_corr.p_alpha(1))])
%     clear x ci y color
%     
%     subplot(2,4,4)
% %     semilogy(eigmax,ft_pl_sim.Tau_prime,'k.','MarkerSize',10)
%     semilogy(eigmax_plus,ft_pl_sim.Tau_prime,'k.','MarkerSize',10)
%     hold on
% %     plot(eigmax(i),ft_pl_sim.Tau_prime(i),'xr')
% %     x = min(eigmax):1e-3:max(eigmax);
%     plot(eigmax_plus(i),ft_pl_sim.Tau_prime(i),'xr')
%     x = min(eigmax_plus):1e-3:max(eigmax_plus);
%     [ci,y] = predint(ft_lin.Tau_prime{1},x,.95,'functional','on');
%     ci = 10.^ci;
%     y = 10.^y;
%     plot(x,y,'g')
%     patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
%         'g','FaceAlpha',0.15, 'LineStyle','none')
%     prettify
%     xlabel('\lambda_1')
%     ylabel('\tau')
%     title(['sim r=' num2str(ft_corr.r_tau_p(1)) ...
%         '; p=' num2str(ft_corr.p_tau_p(1))])
%     clear x ci y
%     
%     subplot(2,4,5)
%     plot_log(dur_emp{i})
%     title(num2str(eigmax(i)))
%     hold on
%     plot_pl_fit(dur_emp{i},ft_pl_emp.Alpha(i),ft_pl_emp.Tau_prime(i),...
%         ft_pl_emp.Xmin(i))
%     
%     subplot(2,4,6)
%     imagesc(nets{i}.A)
%     prettify
%     colorbar
%     n1 = round(1000*-1*min(nets{i}.A(:)));
%     n2 = round(1000*max(nets{i}.A(:)));
%     colormap([linspace(0,1,n1)' linspace(0,1,n1)' ones(n1,1);...
%         ones(n2,1) linspace(1,0,n2)' linspace(1,0,n2)'])
%     clear n1 n2
%     
%     subplot(2,4,7)
%     plot_log(dur_sim_plus{i})
%     title(num2str(eigmax_plus(i)))
%     hold on
%     plot_pl_fit(dur_sim_plus{i},ft_pl_sim.Alpha(i),ft_pl_sim.Tau(i),...
%         ft_pl_sim.Xmin(i))
%     
%     saveas(gcf,[num2str(find(idx==i)) '.png'])
% end
% clear i idx
% %%
% clf
% plot_log(d)
% hold on
% plot_pl_fit(d,ft_pl(1),1/ft_pl(2),ft_pl(3))
% function plot_log(d)
% x = unique(d);
% % x = 10.^(0:0.01:log10(max(d)));
% y = histcounts(d,[x max(x)+1]);
% loglog(x,y./sum(y),'.')
% axis([1 10^4 10^-6 1])
% prettify
% end
% function plot_pl_fit(d,a,t,xmin)
% x = unique(d);
% eq_c = @(a,l,xm) l.^(1-a) ./ igamma(1-a,l.*xm);
% eq_f = @(x,a,l,xm) (x/xm).^-a .* exp(-l.*x);
% eq_l = @(x,a,l,xm) eq_c(a,l,xm) .* eq_f(x,a,l,xm);
% y = eq_l(x,a,1./t,xmin);
% loglog(x,y./sum(y),'b-')
% end
