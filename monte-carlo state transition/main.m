%% Prepare Space
clear; clc;


%% Parameters
n = 15;
m = 1;
A = rand(n).^2;
A = A ./ sum(A);


%% Estimate transition matrix
tic
[P a] = MC_transition(A, m, 1000);
toc


%% Propagate
% Simulation
tic
NT = 10000;
T = 100;
x0 = [ones(NT,1), zeros(NT, n-1)];
[S, pInd] = A_propagate(A, x0, T);
toc

% Markov
p0 = zeros([size(a,2),1]); p0(2) = 1;
p = zeros([size(a,2),T]); p(:,1) = p0;
for i = 2:T
    p(:,i) = P * p(:,i-1);
end
pIndA = sum(pInd);
toc

% Extra Predictor
x = zeros(n, T);
x(:,1) = a(:,2);
for i = 2:T
    x(:,i) = A*x(:,i-1);
end
H = -sum(x.*log2(x), 'omitnan');



figure(1); clf;
subplot(2,2,1);
histogram(sum(P))
subplot(2,2,2);
loglog(-diff(pIndA));
subplot(2,2,3);
plot(p(1,:), pIndA);
subplot(2,2,4);
plot(H, pIndA);

