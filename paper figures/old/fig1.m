
%% generate wrg
p = default_network_parameters;
p.N = 10; p.N_in = 10;
p.frac_conn = 0.3;
p.graph_type = 'weightedrandom';
p.weighting = 'uniform'; p.weighting_params = 1;
p.critical_branching = false;
p.critical_convergence = true;
[A, B] = network_create(p);
figure(1); imagesc(A); colorbar; prettify
%%
figure(2); plot(graph_from_matrix(A))
%% webweb
for i=1:size(A,1)
    nodeNames{i} = ['node number ' num2str(i)];
end; clear i
webweb(A,nodeNames)
%% trigger_avalanches
dur = 15;
trials = 1e3;
a = zeros(p.num_nodes, dur, p.num_nodes, trials);
for n = 1 : p.num_nodes
    for t = 1 : trials
        a(:,:,n,t) = trigger_avalanche3(A,B,...
            inputs(p.num_nodes,{n},1),dur);
    end; clear t
end; clear n
%%
colormap(flipud(gray))
%% view avalanches - matrix
ts = [1 2 4 9];
for n = 8
    for t = ts %1 : trials
        imagesc(1-a(:,:,n,t))
        caxis([0 max(max(max(a(:,:,n,ts))))])
        prettify; colormap gray
        yticklabels(cell(1,p.num_nodes))
        xticklabels(cell(1,dur))
        axis([.5 12.5 0.5 10.5])
        saveas(gcf,['aval_' num2str(t)],'epsc')
    end; clear t
end; clear n
%% get colorbar
n = 8;
imagesc(a(:,:,n,ts(length(ts))))
caxis([0 max(max(max(a(:,:,n,ts))))])
colorbar
prettify
saveas(gcf,'colorbar','pdf')
%% mean avalanche, n = 8
a8_avg = mean(1-a(:,:,8,:),4);
% plot_avalanche(a8_avg, avalanche_transitions(a8_avg, A), true)
imagesc(a8_avg)
prettify; %xlabel('time'); ylabel('neurons')
yticklabels(cell(1,p.num_nodes))
xticklabels(cell(1,dur))
axis([.5 12.5 0.5 10.5])
%%
saveas(gcf,'aval_avg_emp_n8','pdf')
%%
n=8;
a8_lin = avalanche_average_analytical(A,B,inputs(p.num_nodes,{n},1),dur);
imagesc(a8_avg)
prettify; %xlabel('time'); ylabel('neurons')
yticklabels(cell(1,p.num_nodes))
xticklabels(cell(1,dur))
axis([.5 12.5 0.5 10.5])
%%
saveas(gcf,'aval_avg_ana_n8','pdf')
%% diff
histogram(a8_lin(a8_lin>0)-a8_avg(a8_lin>0),30,'FaceColor','k')
prettify
x = -.07 : 0.0001 : .07;
axis([x(1) x(end) 0 20])
%% norm fit
[c,e] = histcounts(a8_lin(a8_lin>0)-a8_avg(a8_lin>0),30);
[muHat, sigmaHat] = normfit(a8_lin(a8_lin>0)-a8_avg(a8_lin>0));
hold on
plot(x,normpdf(x,muHat,sigmaHat)*sum(c.*abs(e(1:end-1))),'k')
hold off
%%
saveas(gcf,'diff_hist_n8','svg')
%% diffs for # nodes
ns = 50 : 50 : 300;
dur = 15;
trials = 1e3;
df = cell(1,length(ns));
a_emp_t = cell(1,length(ns));
a_ana_t = cell(1,length(ns));
nodes_tr = 50;
for i = 1 : length(ns)
    n = ns(i);
    disp(n)
    p = default_network_parameters;
    p.num_nodes = n;
    p.num_nodes_input = p.num_nodes;
    p.num_nodes_output = p.num_nodes;
    p.frac_conn = 0.33;
    p.graph_type = 'WRG';
    p.exp_branching = 1;
    [A, B, C] = network_create(p);
    A = scale_weights_to_criticality(A);
    imagesc(A)
    a_emp = zeros(p.num_nodes, dur, p.num_nodes);
    a_ana = zeros(p.num_nodes, dur, p.num_nodes);
    for nodes = randperm(p.num_nodes, nodes_tr) %1 : p.num_nodes
        u = inputs(p.num_nodes,{nodes},1);
        emp = avalanche_average_empirical(A,B,u,trials,dur);
        ana = avalanche_average_analytical(A,B,u,dur);
        a_emp(:,:,nodes) = emp;
        a_ana(:,:,nodes) = ana;
    end; clear nodes emp ana u
    a_emp_t{i} = a_emp;
    a_ana_t{i} = a_ana;
%     if sum(a_emp>0) < sum(a_emp>0)
%         df{i} = a_emp(a_emp>0) - a_ana(a_emp>0);
%     else
%         df{i} = a_emp(a_ana>0) - a_ana(a_ana>0);
%     end
end; clear n
%%
for i = 1 : length(ns)
%     df{i} = a_emp_t{i}(a_ana_t{i}>0) - a_ana_t{i}(a_ana_t{i}>0);
    df{i} = a_ana_t{i}(a_ana_t{i}>0) - a_emp_t{i}(a_ana_t{i}>0);
end
%% plot diffs
df_m = cellfun(@mean,df)
df_se = cellfun(@std,df);% ./ sqrt(cellfun(@length,df));
errorbar(ns, df_m, df_se, 'ks')
prettify
% axis([0 max(ns) -0.0005 0.0005])
axis([0 max(ns) -0.02 0.02])




