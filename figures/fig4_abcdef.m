
%% network
% NEED TO UPDATE TO USE NETWORK-GENERATOR
rng(1)
p = default_network_parameters;
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.9 0.1 0.1];
% p.weighting = 'uniform';
% p.weighting_params = 1;
% p.weighting = 'gaussian';
% p.weighting_params = [0.5 0.1];
p.N = 100;
p.frac_conn = 0.2;
A = network_create(p);
y0s = pings_single(p.N);
y0sm = cell2mat(y0s);
%% simulate
Ys = cell(1,length(y0s));
T = 1e3;
K = 1e3;
disp('Simulate cascades...')
disp(repmat('#',[1 length(y0s)]))
for i = 1 : length(y0s)
    fprintf('.')
    Ys{i} = avl_smp_many({y0s{i}},1,A,T,K);
end; clear i; fprintf('\n')
%% durations
dur = cell(1,length(y0s));
dm = zeros(1,length(y0s));
for i = 1 : length(y0s)
    dur{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(dur{i});
end; clear i
%% prediction
[v,d] = eig(A');
sumeig = sum(abs((v\y0sm) .* diag(d)));
domeig = max(abs((v\y0sm) .* diag(d)));
%% controllability
finite_time = 100;
ac = finite_impulse_responses(A',finite_time);
mc = control_modal(A');
%% fig4a,d
figure
hold on
scatter(sumeig,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(sumeig',dm',1);
x = min(sumeig) : 1e-2 : max(sumeig);
plot(x,polyval(f,x),'r')
prettify
title('fig4a,d')
%% fig4b,e
figure
hold on
scatter(mc,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(mc,dm',1);
x = min(mc) : 1e-2 : max(mc);
plot(x,polyval(f,x),'r')
prettify
title('fig4b,e');
%% fig4c,f
figure
hold on
scatter(ac,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(ac,dm',1);
x = min(ac) : 1e-2 : max(ac);
plot(x,polyval(f,x),'r')
prettify
title('fig4c,f')
%% correlations
[c_ac,pval_ac] = corr(ac,dm');
[c_se,pval_se] = corr(sumeig',dm');
[c_mc,pval_mc] = corr(mc,dm');
fprintf(['\tSE\tMC\tAC\nCorr:\t%.4f\t%.4f\t%.4f\n'...
    'p-val:\t%.2g\t%.2g\t%.2g\n'],...
    c_se,c_mc,c_ac,pval_se,pval_mc,pval_ac);
