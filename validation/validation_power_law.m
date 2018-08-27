
%% generate network
p = default_network_parameters;
p.N = 100;
p.N_in = p.N;
p.frac_conn = 0.3;
p.graph_type = 'WRG';
p.exp_branching = 1;
[A, B, C] = network_create(p);
A = scale_weights_to_criticality(A);
%% view network
colormap(flipud(gray))
subplot(2,1,1)
imagesc(A)
prettify; colorbar
subplot(2,1,2)
g = graph_from_matrix(A);
plot(g)
prettify
%% drive spontaneous activity
dur = 1e3; iter = 1e4;
[pats, probs] = pings_single(p.N);
tic; [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%% power law - duration
duration = avl_durations_cell(Y);
[alpha_d, xmin_d] = plfit(duration);
plplot(duration, xmin_d, alpha_d)
prettify
%% gof
[p_val_d, gof_d] = plpva(duration, xmin_d);
disp([p_val_d gof_d])
%% power law - size
sizes = avl_sizes_cell(Y);
[alpha_s, xmin_s] = plfit(sizes);
plplot(sizes, xmin_s, alpha_s);
prettify
%% gof
[p_val_s, gof_s] = plpva(sizes, xmin_s);
disp([p_val_s gof_s])
prettify

