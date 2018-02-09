% simulation.m
% simulation of networks
% Written by Harang Ju. January 29, 2018.

%% Parameters
N = 1e2; % number of nodes
frac_conn = 2e-2; % fraction connectivity
step_size = 10e-3; % time (msec)
t_final = 1; % (sec)
activity = 1e-2;
fire_threshold = 1;

%% Initialize
disp('Initializing...')
X = zeros(N,1); % system state, [N X 1]
% A = rand(N) < frac_conn; % system connectivity, [pre X post]
% A = A & ~diag(ones(N,1)); % prevent recursive connectivity
% A = A .* (rand(N) * 0.5 + 0.5);
[~, A] = Weighted_Random_Graph(N, frac_conn/1e1, frac_conn*N*(N-1)/2);
A = A / max(max(A)) * 0.9;
B = ones(N,1); % system input connectivity, [N X 1]
u = zeros(N,1); % system input, [N X 1]

%% Simulation
disp('Simulating...')
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
disp('Plotting...')

u_t = zeros(N,1);
[~, idx_max_ave_c] = sort(avg_control);
[~, idx_max_mod_c] = sort(mod_control);
u_t(idx_max_ave_c(end-1:end),1) = 1;
Y_t = trigger_avalanche(A, B, u_t);
plot_summary(A, avalanche_size(A, B), ave_control(A), modal_control(A),...
    Y_t, avalanche_transitions(Y_t, A))
