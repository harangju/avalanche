
%% sweep parameters
rng(1) 
graph_types = {'weightedrandom','randomgeometric','wattsstrogatz',...
    'mod4comm'};
iter = 30;
%% simulation parameters
T = 1e2; K = 1e3;
stim_mag = 4;
p = default_network_parameters;
p.N = 100;
p.frac_conn = 0.05;
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
%% simulation variables
As = cell(length(graph_types),iter);
pats = cell(length(graph_types),iter);
Ys = cell(length(graph_types),iter);
orders = cell(length(graph_types),iter);
%% simulation
for i = 1 : length(graph_types)
    for j = 1 : iter
        fprintf('%s graph #%d\n',graph_types{i},j)
        % network
        p.graph_type = graph_types{i};
        As{i,j} = network_create(p);
        % stimulus
        ac = finite_impulse_responses(As{i,j}',10);
        [~,order_ac] = sort(ac);
        pats{i,j} = cell(1,p.N/stim_mag);
        for k = 1 : length(pats{i,j})
            pats{i,j}{k} = zeros(p.N,1);
            pats{i,j}{k}(order_ac(1+stim_mag*(k-1) : stim_mag*k)) = 1;
        end
        % stochastic
        disp('Simulate cascades...')
        disp(repmat('#',[1 length(pats{i,j})]))
        Ys{i,j} = cell(1,length(pats{i,j}));
        orders{i,j} = zeros(length(pats{i,j}),K);
        for k = 1 : length(pats{i,j})
            fprintf('.')
            probs = 0.5*ones(1,length(pats{i,j})) / (length(pats{i,j})-1);
            probs(k) = 0.5;
            [Ys{i,j}{k}, orders{i,j}(k,:)] = avl_smp_many(pats{i,j},...
                probs,As{i,j},T,K);
        end; fprintf('\n')
    end
end
%% analysis
durs = cell(length(graph_types),iter);
dms = cell(length(graph_types),iter);
mis = cell(length(graph_types),iter);
fit_mis = cell(length(graph_types),iter);
c_mis = zeros(length(graph_types),iter);
pval_mis = zeros(length(graph_types),iter);
t_range = 1 : 10;
disp('Analysis')
for i = 1 : length(graph_types)
    for j = 1 : iter
        fprintf('%s graph #%d\n',graph_types{i},j)
        % durations
        durs{i,j} = cell(1,length(pats{i,j}));
        dms{i,j} = zeros(length(pats{i,j}),1);
        for k = 1 : length(pats{i,j})
            durs{i,j}{k} = avl_durations_cell(Ys{i,j}{k});
            dms{i,j}(k) = mean(durs{i,j}{k});
        end
        % mutual information
        mis{i,j} = zeros(length(pats{i,j}),T);
        disp('Calculating mutual information...')
        disp(repmat('#',[1 length(pats{i,j})]))
        for k = 1 : length(pats{i,j})
            fprintf('.')
            pat = orders{i,j}(k,:)';
            pat(orders{i,j}(k,:)==k) = 1;
            pat(orders{i,j}(k,:)~=k) = 0;
            m = mutual_info_pop(avl_cell_to_mat(Ys{i,j}{k}),pat);
            mis{i,j}(k,1:length(m)) = m;
        end; fprintf('\n')
        % fits
        fit_mis{i,j} = zeros(length(pats{i,j}),2);
        for k = 1 : length(pats{i,j})
            fit_mis{i,j}(k,:) = polyfit(t_range,mis{i,j}(k,t_range),1);
        end
        % correlations
        [c_mis(i,j), pval_mis(i,j)] = corr(dms{i,j},...
            squeeze(fit_mis{i,j}(:,1)));
    end
end
%% plot summary
figure(5)
boxplot(c_mis')
prettify; axis([.5 4.5 0 1])
%% plot examples
for i = 1 : length(graph_types)
    j=1;
    figure(i); clf
    [~,order_dm] = sort(dms{i,j});
    surf(t_range,dms{i,j}(order_dm),mis{i,j}(order_dm,t_range),...
        'LineWidth',0.01)
    prettify; axis vis3d; view([45 15])
    title(graph_types{i})
end
%% plot example correlation
figure(6); clf; hold on
i=1;j=1;
scatter(dms{i,j},fit_mis{i,j}(:,1),32,[3.1, 18.8, 42]./100,'.')
x = min(dms{i,j}) : 1e-2 : max(dms{i,j});
fit = polyfit(dms{i,j}, squeeze(fit_mis{i,j}(:,1)), 1);
plot(x,polyval(fit,x),'r')
prettify

