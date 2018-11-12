
%% network
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
for i = 1 : length(pats)
    disp(i)
    Ys{i} = avl_smp_many({pats{i}},1,A,T,K);
end; clear i; disp('done')
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
ac = finite_impulse_responses(A',10);
mc = control_modal(A');
%% plot
figure(1); clf;
scatter(ac,dm,'.')
prettify; title('average controllability')
figure(2); clf
scatter(sumeig,dm,'.')
prettify; title('sum \lambda')
figure(3); clf
scatter(mc,dm,'.')
prettify; title('modal controllability')
figure(4); clf
scatter(sumeig,ac,'.')
prettify; xlabel('sum \lambda'); ylabel('avg contr.')
disp([corr(sumeig',dm') corr(ac,dm') corr(sumeig',ac)...
    corr(mc,dm') corr(sumeig',mc)])






