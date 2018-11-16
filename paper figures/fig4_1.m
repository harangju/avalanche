
%% network
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
pats = pings_single(p.N);
patsm = cell2mat(pats);
%% simulate
Ys = cell(1,length(pats));
T = 1e3;
K = 1e3;
disp('Simulate cascades...')
disp(repmat('#',[1 length(pats)]))
for i = 1 : length(pats)
    fprintf('.')
    Ys{i} = avl_smp_many({pats{i}},1,A,T,K);
end; clear i; fprintf('\n')
%% durations
dur = cell(1,length(pats));
dm = zeros(1,length(pats));
for i = 1 : length(pats)
    dur{i} = avl_durations_cell(Ys{i});
    dm(i) = mean(dur{i});
end; clear i
%% prediction
[v,d] = eig(A');
sumeig = sum(abs((v\patsm) .* diag(d)));
domeig = max(abs((v\patsm) .* diag(d)));
%% controllability
% finite_time = 10;
finite_time = 5;
ac = finite_impulse_responses(A',finite_time);
mc = control_modal(A');
%% plot
figure(1); clf; hold on
scatter(ac,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(ac,dm',1);
x = min(ac) : 1e-2 : max(ac);
plot(x,polyval(f,x),'r')
hold off; prettify; title('fir')
% axis([1 1.22 0 40])
figure(2); clf; hold on
scatter(sumeig,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(sumeig',dm',1);
x = min(sumeig) : 1e-2 : max(sumeig);
plot(x,polyval(f,x),'r')
hold off; prettify; title('sum \lambda')
axis([0 30 0 40]) %axis([0 15 0 40])
figure(3); clf; hold on
scatter(mc,dm,32,[3.1, 18.8, 42]./100,'.')
f = polyfit(mc,dm',1);
x = min(mc) : 1e-2 : max(mc);
plot(x,polyval(f,x),'r')
hold off; prettify; title('modal controllability');
axis([0 3 0 40]) %axis([.4 1.6 0 40])
figure(4); clf
scatter(sumeig,ac,'.')
prettify; xlabel('sum \lambda'); ylabel('fir')
[c_ac,pval_ac] = corr(ac,dm');
[c_se,pval_se] = corr(sumeig',dm');
[c_mc,pval_mc] = corr(mc,dm');
fprintf(['\tAC\tMC\tSE\nCorr:\t%.4f\t%.4f\t%.4f\n'...
    'p-val:\t%.2g\t%.2g\t%.2g\n'],...
    c_ac,c_mc,c_se,pval_ac,pval_mc,pval_se);




