%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig4_abc.mat'])
else
    % create network
    n = net.generate('erdosrenyi','n',100,'p',.2,'dir',true);
    % UNCOMMENT for figures d, e, f
%     n = net.distr_weights(n.A,'skewbinorm',...
%         'mus',[.1 .9],'sigma',.001,'props',[.9 .1],'range',[0 1]);
    n.A = n.A ./ sum(n.A,2);
    % simulate
    y0s = pings_single(size(n.A,1));
    y0sm = cell2mat(y0s);
    Ys = cell(1,length(y0s));
    T = 1e3;
    K = 1e3;
    disp('Simulate cascades...')
    disp(repmat('#',[1 length(y0s)]))
    for i = 1 : length(y0s)
        fprintf('.')
        Ys{i} = simulate(@smp,n.A,y0s(i),T,1,K);
    end
    clear i
    fprintf('\n')
    % durations
    durs = cellfun(@csc_durations,Ys,'uniformoutput',0);
    durm = cellfun(@mean,durs);
    % eigenprojection
    [v,d] = eig(n.A);
    sumeig = sum(abs((v\y0sm) .* diag(d)));
    clear v d
    % controllability
    F = 100;
    fac = finite_impulse_responses(n.A,F);
    mc = control_modal(n.A);
    % correlations
    [r_se,pval_se] = corr(sumeig',durm');
    [r_mc,pval_mc] = corr(mc,durm');
    [r_ac,pval_ac] = corr(fac,durm');
    fprintf(['\tSE\tMC\tAC\nCorr:\t%.4f\t%.4f\t%.4f\n'...
        'p-val:\t%.2g\t%.2g\t%.2g\n'],...
        r_se,r_mc,r_ac,pval_se,pval_mc,pval_ac);
end
%% fig4a,d
figure
hold on
plot(sumeig,durm,'k.')
f = polyfit(sumeig',durm',1);
x = min(sumeig) : 1e-2 : max(sumeig);
plot(x,polyval(f,x),'r')
prettify
title('fig4a,d')
%% fig4b,e
figure
hold on
plot(mc,durm,'k.')
f = polyfit(mc,durm',1);
x = min(mc) : 1e-2 : max(mc);
plot(x,polyval(f,x),'r')
prettify
title('fig4b,e');
%% fig4c,f
figure
hold on
plot(fac,durm,'k.')
f = polyfit(fac,durm',1);
x = min(fac) : 1e-2 : max(fac);
plot(x,polyval(f,x),'r')
prettify
title('fig4c,f')
clear f x