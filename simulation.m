% simulation.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Parameters
N = 1e3; % number of nodes
frac_conn = 6e-4; % fraction connectivity
step_size = 1; % time, unitless
t_final = 1e3;
activity = 1e-3;
fire_threshold = 1;

%% Initialize
X = zeros(N,1); % system state, [N X 1]
A = rand(N) < frac_conn; % system connectivity, [pre X post]
A = A & ~diag(ones(N,1)); % prevent recursive connectivity
A = A .* (rand(N) * 0.5 + 0.5);
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
clf

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
xlabel('trial'); ylabel('neuron');
hold off; prettify

subplot(2,2,3)
if N <= 50
    plot_network(A)
else%if false
    sizes = avalanche_size(A, B);
    [n_sizes, edges] = histcounts(sizes, N/1e2);
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
xlabel('trial'); ylabel('neuron');
hold off; prettify

clear x i on
