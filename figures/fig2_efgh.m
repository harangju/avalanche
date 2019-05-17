%% try loading pre-generated data
% NOTE: If generating from scratch, run each section individually
if exist('source_data_dir','var')
    load([source_data_dir '/fig2_efgh.mat'])
else
    disp('Load cascades...')
    cascades_emp = load_cascades(emp_data_dir);
    nets = load_emp_nets(emp_data_dir);
    disp('Calculating eigen measures...')
    eigmax = cellfun(@(x) max(abs(eig(x.A))), sn_w);
    eigsum = cellfun(@(x) sum(abs(eig(x.A))), sn_w);
    disp('Simulating...')
    T = 1e3;
    K = 1e6;
    cascades_sim = cell(1,length(ns));
    for i = 1 : length(ns)
        fprintf(['\tnetwork: ' num2str(i) '/' num2str(length(ns))])
        [y0s,p_y0s] = pings_single(size(ns{i}.A,1));
        cascades_sim{i} = simulate(@smp,ns{i}.A,y0s,T,p_y0s,K);
    end
    clear i y0s p_y0s
    disp('Calculating durations...')
    durs_emp = cellfun(@csc_durations,cascades_emp,'uniformoutput',0);
    durs_sim = cellfun(@csc_durations,cascades_sim,'uniformoutput',0);
    disp('Saving simulated durations')
    durs = durs_sim;
    save('durs','durs','T')
    clear durs
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
end
%% continuing...
if exist('source_data_dir','var') ~= 1
    disp('Calculating correlations...')
    ft_pl_sim = ft_pl;
    clear ft_pl
    ft_pl_a_sim = ft_pl_sim(1,:,1);
    ft_pl_t_sim = 1./ft_pl_sim(1,:,2);
    durs_sim_max = cellfun(@max,durs_sim);
    ft_pl_t_sim(ft_pl_t_sim>durs_sim_max) = ...
        durs_sim_max(ft_pl_t_sim>durs_sim_max);
    clear durs_sim_max
    ft_t_sim = fit(eigmax',log10(ft_pl_t_sim)','poly1');
    ft_a_sim = fit(eigmax',ft_pl_a_sim','poly1');
    [r_t_sim,p_t_sim] = corr(eigmax',ft_pl_t_sim',...
        'Type','Spearman');
    [r_a_sim,p_a_sim] = corr(eigmax',ft_pl_a_sim');
    disp('Saving empirical durations')
    durs = durs_sim;
    Tsim = T;
    T = max(cellfun(@max,durs_emp));
    save('durs','durs','T')
    T = Tsim;
    clear durs Tsim
    disp(['Run fig2_efgh.ipynb in jupyter notebook for exponential'...
        'power laws. Load ft_pl. Then run next section in the script.'])
    save('durs','durs','T')
end
%% continuing... running 
if exist('source_data_dir','var') ~= 1
    ft_pl_emp = ft_pl;
    clear ft_pl;
    ft_pl_a_emp = ft_pl_emp(1,:,1);
    ft_pl_t_emp = 1./ft_pl_emp(1,:,2);
    durs_emp_max = cellfun(@max,durs_emp);
    ft_pl_t_emp(ft_pl_t_emp>durs_emp_max) = ...
        durs_emp_max(ft_pl_t_emp>durs_emp_max);
    clear durs_emp_max
    ft_t_emp = fit(eigmax',log10(ft_pl_t_emp)','poly1');
    ft_a_emp = fit(eigmax',ft_pl_a_emp','poly1');
    [r_t_emp,p_t_emp] = corr(eigmax',log10(ft_pl_t_emp)',...
        'Type','Spearman');
    [r_a_emp,p_a_emp] = corr(eigmax',ft_pl_a_emp');
end
%% fig2e empirical
figure
color = linspecer(1);
semilogy(eigmax,ft_pl_t_sim,'.','MarkerSize',10,'Color',color)
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_t_sim,x,.95,'functional','off');
ci = 10.^ci;
y = 10.^y;
plot(x,y,'Color',color)
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],color,...
    'FaceAlpha',0.1,'LineStyle','none')
hold off
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x ci y
%% fig2f empirical
figure
plot(eigmax,ft_pl_a_sim,'.','MarkerSize',10,'Color',color)
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_a_sim,x,.95,'functional','off');
ci(ci<=0) = 0;
y(y<=0) = 0;
plot(x,y,'Color',color)
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],color,'FaceAlpha',0.1,...
    'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\alpha')
clear x ci y
%% fig2g
figure
clf
semilogy(eigmax,ft_pl_t_emp,'.','MarkerSize',10,'Color',color)
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_t_emp,x,.95,'functional','on');
ci = 10.^ci;
y = 10.^y;
plot(x,y,'Color',color)
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
    color,'FaceAlpha',0.15, 'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\tau')
clear x ci y
%% fig2h
figure
clf
plot(eigmax,ft_pl_a_emp,'.','MarkerSize',10,'Color',color)
hold on
x = min(eigmax):1e-3:max(eigmax);
[ci,y] = predint(ft_a_emp,x,.95,'functional','on');
ci(ci<=0) = 0;
y(y<=0) = 0;
plot(x,y,'Color',color)
patch([x fliplr(x)],[ci(:,1)' fliplr(ci(:,2)')],...
    color,'FaceAlpha',0.15,'LineStyle','none')
prettify
xlabel('\lambda_1')
ylabel('\alpha')
clear x ci y color

