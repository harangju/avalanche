

%% network
p = default_network_parameters;
p.N = 100;
p.N_in = p.N;
p.frac_conn = 0.1;
p.graph_type = 'weightedrandom';
p.weighting = 'bimodalgaussian';
p.weighting_params = [0.1 0.9 0.99 0.01 0.01];
[A, B, C] = network_create(p);
%% 
imagesc(A); prettify; colorbar
%% 
dur = 1e3; iter = 1e4;
%% generate patterns
pats = cell(1,p.N);
for i = 1 : p.N
    x = zeros(p.N,1);
    x(i) = 1;
    pats{i} = x;
end; clear i x
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
%% histogram - predictor
histogram(H_m)
%% modal controllability
mc = control_modal(A);
histogram(mc,30)
prettify
%% finite impulse response
fir = finite_impulse_responses(A,100);
histogram(fir,30)
prettify
%% means
clf; hold on
scatter(H_m,dur_mean,'.')
scatter(mc,dur_mean,'.')
scatter(fir,dur_mean,'.')
hold off
prettify

%% calculate
alphas = 

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
[r,pval] = corr(H_m,dur_mean')
%% spike count per pattern
spike_counts = sum(cell2mat(pats),1);



