
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
figure(1)
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
%% predicted simulation
Yp = zeros(p.num_nodes,dur,length(pats));
for i = 1 : length(pats)
    Yp(:,:,i) = avalanche_average_analytical(A,B,pats{i},dur);
end; clear i
beep
%%
activity = squeeze(sum(Y,1))';
%% fig 1a
figure(1)
plot(mean(activity(1,:),1), 'k', 'LineWidth', .75)
prettify;
set(gca,'LineWidth',.75)
%% measure duration
duration = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        duration(i) = find(activity(i,:)>0,1,'last');
    else
        duration(i) = 0;
    end
end; clear i
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
%% fig 2c
% plot individual durations
figure(2)
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
%%
mc = control_modal(A);
figure(3)
scatter(mc,dur_mean,'.k')
prettify
%%
ac = ave_control(A);
figure(4)
scatter(ac,dur_mean,'.k')
prettify




