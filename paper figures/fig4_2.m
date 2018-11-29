
rng(1)
iter = 30;
% network
p = default_network_parameters;
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
% p.weighting = 'uniform';
% p.weighting_params = 1;
p.N = 100;
p.frac_conn = 0.2;
pats = pings_single(p.N);
patsm = cell2mat(pats);
T = 1e3;
K = 1e3;
As = cell(1,iter);
Ys = cell(iter,length(pats));
for i = 1 : iter
    fprintf('iter: %d\n',i)
    As{i} = network_create(p);
    disp(repmat('#',[1 length(pats)]))
    for j = 1 : length(pats)
        fprintf('.')
        Ys{i,j} = avl_smp_many({pats{j}},1,As{i},T,K);
    end; fprintf('\n')
end; clear i j

%% durations
dur = cell(length(pats),iter);
dm = zeros(length(pats),iter);
for i = 1 : iter
    for j = 1 : length(pats)
        dur{j,i} = avl_durations_cell(Ys{i,j});
        dm(j,i) = mean(dur{j,i});
    end
end; clear i j
%% prediction
% finite_time = 10;
finite_time = 1000;
ac = zeros(length(pats),iter);
mc = zeros(length(pats),iter);
od = zeros(length(pats),iter);
sumeig = zeros(length(pats),iter);
fprintf('iter: ')
for i = 1 : iter
    fprintf('%d ',i)
    ac(:,i) = finite_impulse_responses(As{i}',finite_time);
    mc(:,i) = control_modal(As{i}');
    for j = 1 : length(pats)
        [v,d] = eig(As{i}');
        sumeig(:,i) = sum(abs((v\patsm) .* diag(d)))';
    end
    od(:,i) = sum(As{i},2);
end; clear i j v d; fprintf('done\n')
%% correlations
corr_ac = zeros(iter,1);
corr_mc = zeros(iter,1);
corr_sumeig = zeros(iter,1);
corr_od = zeros(iter,1);
for i = 1 : iter
    corr_ac(i) = corr(ac(:,i),dm(:,i));
    corr_mc(i) = corr(mc(:,i),dm(:,i));
    corr_sumeig(i) = corr(sumeig(:,i),dm(:,i));
%     corr_od(i) = corr(od(:,i),dm(:,i));
end; clear i j
%% plot
clf
boxplot([corr_sumeig corr_ac corr_mc],...
    'Labels',{'ME','AC','MC'})
fprintf(['\tAC\tMC\tME\n'...
    'mean\t%.4f\t%.4f\t%.4f\n'],...
    mean(corr_ac),mean(corr_mc),mean(corr_sumeig))
% boxplot([corr_ac corr_mc corr_sumeig corr_od],...
%     'Labels',{'AC','MC','ME','OD'})
% fprintf(['\tAC\tMC\tME\tOD\n'...
%     'mean\t%.4f\t%.4f\t%.4f\t%.4f\n'],...
%     mean(corr_ac),mean(corr_mc),mean(corr_sumeig),mean(corr_od))
prettify

