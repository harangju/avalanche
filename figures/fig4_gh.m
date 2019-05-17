%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig4_g.mat'])
%     load([source_data_dir '/fig4_h.mat'])
else
    iter = 30;
    T = 1e3;
    K = 1e3;
    ns = cell(1,iter);
    y0s = pings_single(100);
    y0sm = cell2mat(y0s);
    Ys = cell(iter,length(y0s));
    durs = cell(1,iter);
    durm = cell(1,iter);
    sumeig = cell(1,iter);
    fac = cell(1,iter);
    mc = cell(1,iter);
    r_se = zeros(1,iter);
    pval_se = zeros(1,iter);
    r_mc = zeros(1,iter);
    pval_mc = zeros(1,iter);
    r_fac = zeros(1,iter);
    pval_ac = zeros(1,iter);
    for i = 1 : iter
        disp(['Iteration ' num2str(i)])
        % create network
        ns{i} = net.generate('erdosrenyi','n',100,'p',.2,'dir',true);
        % UNCOMMENT for figures h
%         n = net.distr_weights(n.A,'skewbinorm',...
%             'mus',[.1 .9],'sigma',.001,'props',[.9 .1],'range',[0 1]);
        ns{i}.A = ns{i}.A ./ sum(ns{i}.A,2);
        disp('Simulate cascades...')
        disp(repmat('#',[1 length(y0s)]))
        for j = 1 : length(y0s)
            fprintf('.')
            Ys{i,j} = simulate(@smp,ns{i}.A,y0s(j),T,1,K);
        end
        fprintf('\n')
        % durations
        durs{i} = cellfun(@csc_durations,Ys(i,:),'uniformoutput',0);
        durm{i} = cellfun(@mean,durs{i});
        % eigenprojection
        [v,d] = eig(ns{i}.A);
        sumeig{i} = sum(abs((v\y0sm) .* diag(d)));
        clear v d
        % controllability
        F = 100;
        fac{i} = finite_impulse_responses(ns{i}.A,F);
        mc{i} = control_modal(ns{i}.A);
        % correlations
        [r_se(i),p_se(i)] = corr(sumeig{i}',durm{i}');
        [r_mc(i),p_mc(i)] = corr(mc{i},durm{i}');
        [r_fac(i),p_fac(i)] = corr(fac{i},durm{i}');
    end
clear i j
end
%% fig4g,h
figure
boxplot([r_se r_mc r_fac],...
    'Labels',{'ME','MC','AC'})
fprintf(['\tSE\tMC\tAC\n'...
    'mean\t%.4f\t%.4f\t%.4f\n'],...
    mean(r_se),mean(r_mc),mean(r_fac))
prettify

