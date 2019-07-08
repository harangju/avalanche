% adopted from Neural Complexity Toolbox

%% load data
cascades = load_cascades(emp_data_dir);
%% calculate size duration size|duration
drs = cellfun(@csc_durations,cascades,'un',0);
szs = cellfun(@csc_sizes,cascades,'un',0);
%%
save('stats','szs','drs')
disp(['Run sfig8.ipynb in jupyter notebook for '...
        'power laws. Load ft_pl. Then run next section in the script.'])
%%
ft_pl = table(...
    ft_pl(:,1), ft_pl(:,2), ft_pl(:,3),...
    'VariableNames',{'tau','alpha','xmin'});
%%
sgd = zeros(length(drs),1);
sgd_inv = zeros(length(drs),1);
sgd_log_coeff = zeros(length(drs),1);
for i = 1 : length(drs)
    [sgd(i), sgd_inv(i), sgd_log_coeff(i)] =...
        sizegivdurwls(szs{i}, drs{i},...
        'durmin', ft_pl.xmin(i), 'durmax', max(drs{i}));
end
clear i
%%
exprel = (ft_pl.alpha-1)./(ft_pl.tau-1);
%% figure
figure
clf
hold on
plot(1:length(drs), exprel, '+')
for i = 1 : length(sgd)
    errorbar(i, sgd(i), sgd_inv(i), 'r')
end
clear i
%% figure
color = linspecer(3);
% figure
clf
for i = 1 : length(drs)
    subplot(5,5,i)
    drs_above = drs{i}(drs{i}>ft_pl.xmin(i));
    szs_above = szs{i}(drs{i}>ft_pl.xmin(i));
    drs_below = drs{i}(drs{i}<ft_pl.xmin(i));
    szs_below = szs{i}(drs{i}<ft_pl.xmin(i));
    x = unique(drs_above);
    ysgd = x.^sgd(i) * 10^sgd_log_coeff(i);
    yexp = x.^exprel(i) * 10^sgd_log_coeff(i);
    loglog(drs_above,szs_above,'k.','MarkerSize',6)
    hold on
    loglog(drs_below,szs_below,...
        '.','MarkerSize',6,'Color',color(3,:))
    loglog(x,ysgd,'Color',color(1,:),'LineWidth',1.5)
    loglog(x,yexp,'--','Color',color(2,:),'LineWidth',1.5)
    prettify
end
clear i x drs_* szs_*x y* ci
