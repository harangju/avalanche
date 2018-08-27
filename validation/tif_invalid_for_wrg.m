
%% network
prm = default_network_parameters;
N = 100;
prm.num_nodes = N;
prm.num_nodes_input = N;
prm.frac_conn = 0.3;
prm.graph_type = 'WRG';
[A, B, C] = network_create(prm);
A = scale_weights_to_criticality(A);
%% 
dur = 1e3; iter = 1e4;
%% generate patterns, 1
pats = cell(1,N);
for i = 1 : N
    x = zeros(N,1);
    x(i) = 1;
    pats{i} = x;
end; clear i x
%% generate patterns, 2
input_activity = 0.1;
pat_num = 100;
pats = cell(1,pat_num);
for i = 1 : pat_num
    pats{i} = double(rand(prm.num_nodes,1) < input_activity);
end; clear i
%% simulation
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%% calculate duration
duration = avl_durations_cell(Y);
dur_mean = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_mean(i) = mean(duration(pat==i));
end; clear i
dur_med = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_med(i) = median(duration(pat==i));
end; clear i
%% calculate predictor
T = 100;
H = zeros(length(pats),T);
for i = 1 : length(pats)
    H(i,:) = avl_predictor(A,pats{i},T);
end; clear i
H_m = mean(H.*(1:T),2);
H_m(isnan(H_m)) = 0;
%% plot individual durations
scatter(H_m,dur_mean,'.k')
prettify
xlabel('T_{IF}'); ylabel('mean duration')
%% plot durations by spike counts
[uniq_counts, ~, ic] = unique(spike_counts);
colors = linspecer(length(uniq_counts));
clf; hold on
for i = 1 : length(uniq_counts)
    scatter(H_m(ic==i), dur_mean(ic==i), 100, colors(i,:), '.')
end
hold off
prettify
xlabel('T_{IF}'); ylabel('mean duration')
legs = cell(1,length(uniq_counts));
for i = 1 : length(uniq_counts)
    legs{i} = num2str(uniq_counts(i));
end
legend(legs)
%% fit
f = polyfit(H_m,dur_mean',1);
hold on
x = min(H_m) : 1e-2 : max(H_m);
plot(x,polyval(f,x))
hold off
%% pearson correlation
[r,p] = corr(H_m,dur_mean')
%% spike count per pattern
spike_counts = sum(cell2mat(pats),1);




