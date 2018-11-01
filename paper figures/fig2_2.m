%% simulate graph types
% ns = 50 : 50 : 300;
graph_types = {'weightedrandom','ringlattice','mod4comm','wattsstrogatz'};
iter = 30;
dur = 100;
N = 12;
trials = 1e4;
Ys = cell(length(graph_types),iter,N);
As = cell(length(graph_types),iter);
for i = 1 : length(graph_types)
    disp(graph_types{i})
    for j = 1 : iter
        disp(['iteration: ' num2str(j)])
        p = default_network_parameters;
        p.N = N; p.N_in = N;
        p.frac_conn = 0.2;
        p.graph_type = graph_types{i};
        p.weighting = 'uniform'; p.weighting_params = 1;
        p.critical_branching = false;
        p.critical_convergence = true;
        As{i,j} = network_create(p);
        pats = pings_single(p.N);
        for k = 1 : N
            Ys{i,j,k} = avl_smp_many({pats{k}},1,As{i,j},dur,trials);
        end
    end
end; clear i n A B pats probs
%% 
S = states(N);
pats = pings_single(N);
fs = cell(length(graph_types),iter,N);
fps = cell(length(graph_types),iter,N);
rmses = zeros(length(graph_types),iter,N);
for i = 1 : length(graph_types)
    disp(graph_types{i})
    for j = 1 : iter
        disp(['iteration: ' num2str(j)])
        T = p_transition(As{i,j},S);
        for k = 1 
            fs{i,j,k} = avl_fraction_alive(Ys{i,j,k});
            p1 = p_state(pats{k},S);
            P = p_states(p1,T,dur);
            fps{i,j,k} = 1 - P(1,1:length(fs{i,j,k}));
            rmses(i,j,k) = sqrt(mean((fs{i,j,k} - fps{i,j,k}).^2));
        end
    end
end
%% plot
% figure(1)
% boxplot(reshape(rmses, [length(graph_types), iter*N])')
% prettify
mean(reshape(rmses, [4,30*12]),2)'
max(reshape(rmses, [4,30*12])')

