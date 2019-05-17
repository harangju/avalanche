%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig5.mat'])
else
    % sweep parameters
    iter = 30;
    graphs = {'weightedrandom','randomgeometric','wattsstrogatz',...
        'modular'};
    % simulation
    T = 1e2;
    K = 1e3;
    F = 10;
    stim_mag = 4;
    ns = cell(length(graphs),iter);
    y0s = cell(length(graphs),iter);
    Ys = cell(length(graphs),iter);
    i_y0s = cell(length(graphs),iter);
    for i = 1 : length(graphs)
        disp(['Graph: ' graphs{i}])
        for j = 1 : iter
            fprintf(['\t # ' num2str(j) '\n'])
            % network & stimulus
            switch i
                case 1
                    ns{i,j} = net.generate('erdosrenyi',...
                        'n',100,'p',0.05,'dir',true);
                case 2
                    ns{i,j} = net.generate('randomgeometric',...
                        'n',100,'radius',.139);
                case 3
                    ns{i,j} = net.generate('wattsstrogatz',...
                        'n',100,'k',.05*100,'p',.1);
                case 4
                    ns{i,j} = net.generate('modular',...
                        'n',100,'k',.025*100^2,'m',4);
            end
            ns{i,j}.A = ns{i,j}.A ./ sum(ns{i,j}.A,2);
            ns{i,j}.A(isnan(ns{i,j}.A)) = 0;
            y0s{i,j} = inputs_fac(ns{i,j}.A,F,stim_mag);
            % simulation
            fprintf('\tSimulate cascades...\n')
            fprintf(['\t' repmat('#',[1 length(y0s{i,j})]) '\n\t'])
            Ys{i,j} = cell(1,length(y0s{i,j}));
            i_y0s{i,j} = zeros(length(y0s{i,j}),K);
            for k = 1 : length(y0s{i,j})
                fprintf('.')
                probs = 0.5 * ones(1,length(y0s{i,j})) /...
                    (length(y0s{i,j})-1);
                probs(k) = 0.5;
                [Ys{i,j}{k}, i_y0s{i,j}(k,:)] = simulate(@smp,...
                    ns{i,j}.A,y0s{i,j},T,probs,K);
            end
            clear probs
            fprintf('\n')
        end
    end
    % analysis
    durs = cell(length(graphs),iter);
    durm = cell(length(graphs),iter);
    mis = cell(length(graphs),iter);
    fit_mis = cell(length(graphs),iter);
    r_mis = zeros(length(graphs),iter);
    p_mis = zeros(length(graphs),iter);
    t_range = 1 : 10;
    disp('Analysis')
    for i = 1 : length(graphs)
        for j = 1 : iter
            fprintf('%s graph #%d\n',graphs{i},j)
            % durations
            durs{i,j} = cellfun(@csc_durations,Ys{i,j},'uniformoutput',0);
            durm{i,j} = cellfun(@mean,durs{i,j});
            % mutual information
            mis{i,j} = zeros(length(y0s{i,j}),T);
            disp('Calculating mutual information...')
            disp(repmat('#',[1 length(y0s{i,j})]))
            for k = 1 : length(y0s{i,j})
                fprintf('.')
                y0 = i_y0s{i,j}(k,:)';
                y0(i_y0s{i,j}(k,:)==k) = 1;
                y0(i_y0s{i,j}(k,:)~=k) = 0;
                mis{i,j}(k,1:length(m)) = ...
                    mutual_info_pop(csc_cell_to_mat(Ys{i,j}{k}),y0);
            end
            fprintf('\n')
            % fits
            fit_mis{i,j} = zeros(length(y0s{i,j}),2);
            for k = 1 : length(y0s{i,j})
                fit_mis{i,j}(k,:) = polyfit(t_range,mis{i,j}(k,t_range),1);
            end
            % correlations
            [r_mis(i,j), p_mis(i,j)] = corr(durm{i,j}',...
                squeeze(fit_mis{i,j}(:,1)));
        end
    end
    clear i j k m
    % correlate mean of eigenvalues with mean MI decay
    me = cellfun(@(x) mean(abs(eig(x.A))),ns(:));
    slopes = cellfun(@(x) mean(x(:,1)),fit_mis(:));
    [r_me_fit_mis, p_me_fit_mis] = corr(me, slopes);
end
%% fig5efgh
for i = 1 : length(graphs)
    figure
    j = 1;
    [~,order_durm] = sort(durm{i,j});
    surf(t_range,durm{i,j}(order_durm),mis{i,j}(order_durm,t_range),...
        'LineWidth',0.01)
    prettify
    axis vis3d
    view([45 15])
    title(graphs{i})
end
clear i j order_durm
%% fig5i
i = 1;
j = 1;
figure
hold on
plot(durm{i,j},fit_mis{i,j}(:,1),'.k','MarkerSize',10)
f = polyfit(durm{i,j}',fit_mis{i,j}(:,1),1);
x = min(durm{i,j}) : .1 : max(durm{i,j});
plot(x,polyval(f,x),'r')
clear i j f x
%% fig5j
figure
boxplot(r_mis')
prettify
axis([.5 4.5 0 1])
%% fig5k
figure
hold on
colors = linspecer(4);
for i = 1 : length(graphs)
%     plot(me(1+(i-1)*iter : i*iter),...
%         slopes(1+(i-1)*iter : i*iter),...
%         '.','Color',colors(i,:),'MarkerSize',10)
    plot(me(sub2ind([length(graphs) iter], i*ones(1,iter), 1:iter)),...
        slopes(sub2ind([length(graphs) iter], i*ones(1,iter), 1:iter)),...
        '.','Color',colors(i,:),'MarkerSize',10)
end
clear i
legend(graphs)
f = polyfit(me,slopes,1);
x = min(me(:)) : 1e-3 : max(me(:));
plot(x,polyval(f,x),'r')
prettify
clear colors f x
