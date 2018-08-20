
%% network
p = default_network_parameters;
p.num_nodes = 100;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
% p.frac_conn = 0.1;
p.frac_conn = 0.33;
p.graph_type = 'WRG';
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);
%% view
imagesc(A)
colorbar
prettify
%% check connectivity
disp(mean(A(:)>0))
%%
imagesc(A)
prettify; axis square; colorbar
%%
dur = 300; iter = 3e3;
%% 
input_activity = 0.1;
pat_num = 100;
pats = cell(1,pat_num);
for i = 1 : pat_num
    pats{i} = rand(p.num_nodes,1) < input_activity;
end; clear i
%% simulation
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%% fig 1a
figure(1)
plot(mean(sum(Y{1},1),1), 'k', 'LineWidth', .75)
prettify;
set(gca,'LineWidth',.75)
%% measure duration
duration = avalanche_durations_cell(Y);
%% mean duration
dur_mean = zeros(1,length(pats));
for i = 1 : length(pats)
    dur_mean(i) = mean(duration(pat==i));
end; clear i
%% predictor
H = zeros(length(pats),dur);
for i = 1 : length(pats)
    H(i,:) = avalanche_predictor(A,pats{i},dur);
end; clear i
H_m = mean(H.*(1:dur),2);
H_m(isnan(H_m)) = 0;
%% fig 2b
figure(2); clf
pat_ex = 4;
plot(H(pat_ex,:))
hold on
histogram(duration(pat==pat_ex),30)
hold off
%% fig 2c
% plot individual durations
figure(3)
scatter(H_m,dur_mean,'.k')
prettify
%% linear fit
f = polyfit(H_m,dur_mean',1);
hold on
x = 10:0.1:max(H_m);
plot(x,polyval(f,x),'r')
hold off
%% pearson correlation
[r,p] = corr(H_m,dur_mean'); disp(r)



