
%% network
prm = default_network_parameters;
N = 100;
prm.num_nodes = N;
prm.num_nodes_input = N;
prm.frac_conn = 0.1;
% prm.p_rewire = 0.4;
prm.graph_type = 'WRG';
[A, B, C] = network_create(prm);
A = scale_weights_to_criticality(A);
%% view
figure(1)
imagesc(A)
colorbar
prettify
%%
dur = 1e3; iter = 1e4;
%% 
pats = cell(1,N);
for i = 1 : N
    x = zeros(N,1);
    x(i) = 1;
    pats{i} = x;
end; clear i x
%%
input_activity = 0.02;
pat_num = 100;
pats = cell(1,pat_num);
for i = 1 : pat_num
    pats{i} = double(rand(prm.num_nodes,1) < input_activity);
end; clear i
%%
pats = cell(1,N);
pat_num = 100;
num_on = 10;
for i = 1 : pat_num
    pats{i} = zeros(N,1);
    pats{i}(randperm(N,num_on)) = 1;
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
scatter(H_m(dur_mean<100),dur_mean(dur_mean<100),'.k')
% scatter(H_m,dur_mean,'.k')
prettify
%% linear fit
f = polyfit(H_m(dur_mean<100),dur_mean(dur_mean<100)',1);
% f = polyfit(H_m,dur_mean',1);
hold on
x = min(H_m):0.001:max(H_m);
plot(x,polyval(f,x),'r')
hold off
%% pearson correlation
[r,p] = corr(H_m(dur_mean<100),dur_mean(dur_mean<100)')
% [r,p] = corr(H_m,dur_mean'); disp(r)
%%
mc = control_modal(A);
figure(3)
scatter(mc(dur_mean<100),dur_mean(dur_mean<100),'.k')
% scatter(mc,dur_mean,'.k')
prettify
%%
f = polyfit(mc(dur_mean<100),dur_mean(dur_mean<100)',1);
hold on
x = min(mc(dur_mean<100)) : 0.001 : max(mc(dur_mean<100));
plot(x,polyval(f,x),'r')
hold off
[r,p] = corr(mc(dur_mean<100),dur_mean(dur_mean<100)')
% [r,p] = corr(mc,dur_mean')
%%
fir = finite_impulse_responses(A,T);
%%
figure(4)
scatter(fir(dur_mean<100),dur_mean(dur_mean<100),'.k')
% scatter(fir,dur_mean,'.k')
prettify
%%
f = polyfit(fir(dur_mean<100),dur_mean(dur_mean<100)',1);
% f = polyfit(fir,dur_mean',1);
hold on
x = min(fir):0.001:max(fir(dur_mean<100));
plot(x,polyval(f,x),'r')
hold off
%%
[r,p] = corr(fir(dur_mean<100),dur_mean(dur_mean<100)')
% [r,p] = corr(fir,dur_mean')

%%
activity = zeros(length(pats),dur);
for i = 1 : length(pats)
    Y = avalanche_average_analytical(A,B,pats{i},dur);
    activity(i,:) = sum(Y,1);
end; clear i
plot(activity')








