% simulation.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Parameters
N = 1e2; % number of nodes
frac_conn = 1e-1; % fraction connectivity
step_size = 10e-3; % time (msec)
t_final = 1; % (sec)
activity = 1e-3;
fire_threshold = 1;

%% Initialize
X = zeros(N,1); % system state, [N X 1]
% A = rand(N) < frac_conn; % system connectivity, [pre X post]
% A = A & ~diag(ones(N,1)); % prevent recursive connectivity
% A = A .* (rand(N) * 0.5 + 0.5);
[~, A] = Weighted_Random_Graph(N, frac_conn, frac_conn*N*(N-1)/2);
B = ones(N,1); % system input connectivity, [N X 1]
u = zeros(N,1); % system input, [N X 1]

%% Simulation
X_t = zeros(N,t_final/step_size);
u_t = zeros(size(X_t));
for t = 1 : t_final/step_size
    u = rand(N,1) < activity;
    u_t(:,t) = u;
    X = A' * X + B .* u;
    X_t(:,t) = X;
end

clear t

%% Plot
figure(1); clf

subplot(2,2,1);
imagesc(A); title('connectivity')
set(gca,'YDir','normal')
xlabel('post-'); ylabel('pre-')
colorbar; axis square; prettify

x = (1:t_final/step_size) * step_size;
subplot(2,2,2); hold on
for i = 1 : N
    on = u_t(i,:) > 0;
    if max(on) == 0
        plot(0); continue
    end
    plot(x(on), i*on(on), '.', 'MarkerSize', 5)
end
title('inputs')
axis([0 t_final 0 N+0.5]); axis square
xlabel('time (ms)'); ylabel('neuron');
hold off; prettify

subplot(2,2,3)
if N <= 50
    plot_network(A)
else%if false
    sizes = avalanche_size(A, B);
    [n_sizes, edges] = histcounts(sizes);
    bar(edges(2:end), n_sizes)
    xlabel('avalanche size'); ylabel('number of avalanches')
    axis square; prettify
end

subplot(2,2,4); hold on
for i = 1 : N
    on = X_t(i,:) >= fire_threshold;
    if max(on) == 0
        plot(0); continue
    end
    on_u = u_t(i,:) > 0;
    plot(x(on), i*on(on), '.', 'MarkerSize', 5)
end
title('activity raster')
axis([0 t_final 0 N+0.5]); axis square
xlabel('time (ms)'); ylabel('neuron');
hold off; prettify

%% Plot controllability

figure(2); clf

subplot(1,2,1); hold on
ave_c = ave_control(A);
[n_ave_c, e_ave_c] = histcounts(ave_c);
plot(e_ave_c(2:end), n_ave_c, '-o')
mod_c = modal_control(A);
[n_mod_c, e_mod_c] = histcounts(mod_c);
plot(e_mod_c(2:end), n_mod_c, '-o')
legend({'average', 'modal'})
prettify; axis square; xlabel('controllability'); ylabel('number of neurons')

subplot(1,2,2);
u_t = zeros(N,1);
[~, idx_max_ave_c] = max(ave_c);
[~, idx_max_mod_c] = max(mod_c);
u_t(idx_max_ave_c,1) = 1;
[X_t, trans] = trigger_avalanche(A,B,u_t);
% plot_avalanche(X_t, trans)
imagesc(X_t); colorbar; caxis([0 1e4])
prettify; axis square; xlabel('time unit'); ylabel('neuron')

clear x i on
