
%% generate wrg
p = default_network_parameters;
p.num_nodes = 10;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.33;
p.graph_type = 'WRG';
p.exp_branching = 1;
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
%% view avalanches
for n = 8 %[10 5 8] %1 : p.num_nodes
    for t = 1 : trials
        plot_avalanche(a(:,:,n,t),avalanche_transitions(a(:,:,n,t),A),...
            true);
        title([num2str(n) ' ' num2str(t)])
        pause
    end; clear t
end; clear n
%% view avalanches - matrix
for n = 8
    for t = 1 : trials
        imagesc(-1*a(:,:,n,t))
        prettify; %colorbar;% xlabel('time'); ylabel('neurons')
        saveas(gcf,['aval_' num2str(t) '.eps'])
%         pause
    end; clear t
end; clear n
%% mean avalanche, n = 8
a8_avg = mean(a(:,:,8,:),4);
% plot_avalanche(a8_avg, avalanche_transitions(a8_avg, A), true)
imagesc(a8_avg)
prettify; colorbar; xlabel('time'); ylabel('neurons')
%%
n=8;
a8_lin = avalanche_average_analytical(A,B,inputs(p.num_nodes,{n},1),dur);
imagesc(a8_avg)
prettify; colorbar; xlabel('time'); ylabel('neurons')
%% diff
histogram(a8_lin(:)-a8_avg(:),40)
prettify
axis([-.02 .02 0 100])


