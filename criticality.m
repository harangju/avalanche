

%% generate network
load('beggs data/DataSet1.mat')
A = estimate_network_from_spikes(data, 0.1);
B = ones(size(A,1),1);
A = scale_weights_to_criticality(A);

%% driven mode
% given A, B
iter = 1e3; dur = 7;
Y = ping_nodes(A, B, iter, dur);

%% spontaneous mode
p_spont = 0.0003;
iter = 1e3;
Y_cont = spontaneous_avalanches(A, B, p_spont, iter);
Y = find_avalanches(Y_cont);

%% exponential fit of avalanche size
bins = 20;
[s, e] = avalanche_size_distr(Y, bins);
f = avalanche_size_distr_exp_fit(s,e);
disp(['Slope: ' num2str(f.b)])
plot(f,e(2:end),log10(s)); prettify; axis square
