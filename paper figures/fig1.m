
%% generate wrg
p = default_network_parameters;
p.num_nodes = 10;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.33;
p.graph_type = 'WRG';
p.exp_branching = 1;
%%
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);
%%
g = graph_from_matrix(A);
plot(g)
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
ts = 1:10;
for n = 8
    for t = ts %1 : trials
        imagesc(a(:,:,n,t))
        caxis([0 max(max(max(a(:,:,n,ts))))])
        prettify; %colorbar;% xlabel('time'); ylabel('neurons')
        saveas(gcf,['aval_' num2str(t)],'svg')
%         pause
    end; clear t
end; clear n
%% get colorbar
n = 8;
imagesc(a(:,:,n,ts(length(ts))))
caxis([0 max(max(max(a(:,:,n,ts))))])
colorbar
prettify
saveas(gcf,'colorbar','svg')
%% mean avalanche, n = 8
a8_avg = mean(a(:,:,8,:),4);
% plot_avalanche(a8_avg, avalanche_transitions(a8_avg, A), true)
imagesc(a8_avg)
prettify; %xlabel('time'); ylabel('neurons')
saveas(gcf,'aval_avg_emp_n8','svg')
%%
n=8;
a8_lin = avalanche_average_analytical(A,B,inputs(p.num_nodes,{n},1),dur);
imagesc(a8_avg)
prettify; %xlabel('time'); ylabel('neurons')
saveas(gcf,'aval_avg_ana_n8','svg')
%% diff
histogram(a8_lin(a8_lin>0)-a8_avg(a8_lin>0),30,'FaceColor','k')
prettify
axis([-.07 .07 0 15])
saveas(gcf,'diff_hist_n8','svg')
%% diffs for # nodes
ns = 50 : 50 : 300;
dur = 15;
trials = 1e3;
df = cell(1,length(ns));
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
    for nodes = 1 : p.num_nodes
        u = inputs(p.num_nodes,{nodes},1);
        emp = avalanche_average_empirical(A,B,u,trials,dur);
        ana = avalanche_average_analytical(A,B,u,dur);
        a_emp(:,:,nodes) = emp;
        a_ana(:,:,nodes) = ana;
    end; clear nodes emp ana u
    if sum(a_emp>0) < sum(a_emp>0)
        df{i} = a_emp(a_emp>0) - a_ana(a_emp>0);
    else
        df{i} = a_emp(a_ana>0) - a_ana(a_ana>0);
    end
end; clear n




