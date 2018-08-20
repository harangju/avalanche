
%% network
prm = default_network_parameters;
N = 100;
prm.num_nodes = N;
prm.num_nodes_input = N;
prm.frac_conn = 0.33;
prm.graph_type = 'WRG';
[A, B, C] = network_create(prm);
A = scale_weights_to_criticality(A);
%% view
figure(1)
imagesc(A)
colorbar
prettify
%%
dur = 1e4; iter = 1e4;
%% 
pats = cell(1,N);
for i = 1 : N
    x = zeros(N,1);
    x(i) = 4;
    pats{i} = x;
end; clear i x
%%
input_activity = 0.2;
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
duration = avalanche_durations_cell(Y);
dur_mean = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_mean(i) = mean(duration(pat==i));
end; clear i
%% predictor
T = 100;
H = zeros(length(pats),T);
for i = 1 : length(pats)
    H(i,:) = avalanche_predictor(A,pats{i},T);
end; clear i
H_m = mean(H.*(1:T),2);
H_m(isnan(H_m)) = 0;
%% fig 2c
% plot individual durations
figure(2)
scatter(H_m,dur_mean,'.k')
prettify
%% linear fit
f = polyfit(H_m,dur_mean',1);
hold on
% x = 10:0.1:max(H_m);
x = 0:0.1:max(H_m);
plot(x,polyval(f,x),'r')
hold off
%% pearson correlation
[r,p] = corr(H_m,dur_mean'); disp(r)
%%
mc = control_modal(A);
figure(3)
scatter(mc,dur_mean,'.k')
prettify
%%
[r,p] = corr(mc,dur_mean')
%%
fir = finite_impulse_responses(A,dur);
figure(4)
scatter(fir,dur_mean,'.k')
prettify
%%
[r,p] = corr(fir,dur_mean')




