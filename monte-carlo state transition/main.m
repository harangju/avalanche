%% Prepare Space
clear; clc;


%% Parameters
n = 20;                     % Number Neurons
m = 1;                      % 
A = rand(n).^3;             % Adjacency Matrix
A = A ./ sum(A);            % Normalize to get out-strength = 1


%% Estimate transition matrix
% tic
% [P a] = MC_transition(A, m, 1000);
% toc


%% Simulation
NT = 10000;                 % Number Trials
T = 100;                    % Number Time Steps
xInd = 1;                   % Not important, keep at 1
a = zeros([n,1]); 
a([1 2 3]) = 1;             % Stimulus vector

% Simulate
x0 = repmat(a(:,xInd), [1, NT])';
[S, pInd] = A_propagate(A, x0, T);
pIndA = sum(pInd);          % Number neurons alive at time bins


%% Markov
% p0 = zeros([size(a,2),1]); p0(2) = 1;
% p = zeros([size(a,2),T]); p(:,1) = p0;
% for i = 2:T
%     p(:,i) = P * p(:,i-1);
% end
% toc


%% Extra Predictor
x = zeros(n, T);            % Expected Value
v = zeros(n, T);            % Uppder Bound on Variance
x(:,1) = a(:,xInd);         % Initialize
v(:,1) = a(:,xInd);
% Compute components purely structure based predictor
for i = 2:T
    x(:,i) = A*x(:,i-1);
    v(:,i) = (A - A.^2)*x(:,i-1) + A*v(:,i-1);
end
% H = -sum(x.*log2(x), 'omitnan');
% H = sum(x ./ sqrt(v));
H = mean(x./v, 'omitnan').^(1/sum(a(:,xInd)));  % Structural Predictor


% Plot
figure(1); clf;
subplot(2,2,1);
% histogram(sum(P))
subplot(2,2,2);
loglog(-diff(pIndA));
xlabel('Time Step');
ylabel('Number Dead at Time Step');
subplot(2,2,3);
% plot(1-p(1,:), pIndA/NT);
subplot(2,2,4);
plot(H, pIndA/NT);
xlabel('Structural Predictor');
ylabel('Simulated Fraction Alive');

