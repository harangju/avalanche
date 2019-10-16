%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig4_i.mat'])
else
    % load empirical data
    cascades = load_cascades(emp_data_dir);
    nets = load_emp_nets(emp_data_dir);
    durations = cellfun(@csc_durations,cascades,'uniformoutput',0);
    % calculate finite average controllability
    disp('Calculating average controllability...')
    F = 100; % lower to speed up analysis
    fac = cell(1,length(nets));
    for i = 1 : length(nets)
        disp(['\tnetwork ' num2str(i)])
        fac{i} = finite_impulse_responses(nets{i}.A,F);
    end
    % controllability of x0
    disp('Calculating controllability of initial states...')
    Ts = 1:10;
    fac_x0 = cell(length(nets),length(Ts));
    for i = 1 : length(cascades)
        fprintf(['\t recording ' num2str(i) '; t ='])
        for j = 1 : length(Ts)
            fprintf([' ' num2str(j)])
            fac_x0{i,j} = zeros(1,length(cascades{i}));
            for k = 1 : length(cascades{i})
                T = min( Ts(j), size(cascades{i}{k},2) );
                active = sum(cascades{i}{k}(:,1:T),2) > 0;
                fac_x0{i,j}(k) = ...
                    sum(fac{i}(active)) / sum(active);
            end
        end
        fprintf('\n')
    end
    clear T active
    disp('Calculating correlations...')
    ps = zeros(length(nets),length(Ts));
    rs = zeros(length(nets),length(Ts));
    for i = 1 : length(nets)
        for j = 1 : length(Ts)
            [rs(i,j),ps(i,j)] =...
                corr(fac_x0{i,j}',durations{i}','Type','Spearman');
        end
    end
    clear i j k
end
%% fig4i
figure
hold on
boxplot(rs)
plot(Ts, rs, 'k.')
prettify
% axis([.5 4.5 -.05 .5])
%% display stats
disp('Spearmans rho')
disp(rs)
disp('p-value')
disp(ps)
disp('Medians')
disp(median(rs))
