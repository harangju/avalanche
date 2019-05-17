%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig3_a.mat'])
else
    % network
    n = net.generate('erdosrenyi','n',10,'p',0.2,'dir',true);
    n.A = n.A./sum(n.A,1);
    n.A(isnan(n.A)) = 0;
    Tmax = 100;
    K = 1e6;
    neur = 8;
    % simulation
    disp('Simulating...')
    y0s = pings_single(size(n.A,1));
    [Y,i_y0s] = simulate(@smp,n.A',y0s(neur),Tmax,1,K);
    dur = csc_durations(Y);
    f = fraction_alive(dur);
    % prediction
    disp('Predicting state transitions...')
    S = states(size(n.A,1));
    T = p_transition(n.A,S);
    p1 = p_state(y0s{neur},S);
    P = p_states(p1,T,Tmax);
    fp = 1 - P(1,1:max(dur));
    rmse = sqrt(mean((f-fp).^2));
end
%% fig2a
figure
imagesc(n.A)
prettify
%% fig2b
figure
loglog(1:length(f),f,'.')
hold on
loglog(1:length(fp),fp)
hold off
clear x
%% fig2c
figure
plot(sum(Y{find(dur>20,1)}))
