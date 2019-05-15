%% uncomment to use same data from paper, Ju et al. 2019
basedir = '~/Downloads/Source Data';
%% a
if exist('basedir','var')
    load([basedir '/fig2_abc'])
else
    n = net.generate('erdosrenyi','n',10,'p',0.2,'dir',true);
    n.A = n.A./sum(n.A,1);
    n.A(isnan(n.A)) = 0;
end
figure
imagesc(A)
%% b
if ~exist('basedir','var')
    Tmax = 100;
    K = 1e6;
    neur = 8;
    % simulation
    y0s = pings_single(size(n.A,1));
    [Y,i_y0s] = simulate(@smp,n.A',y0s(neur),Tmax,1,K);
    dur = durations(Y);
    f = fraction_alive(dur);
    % prediction
    S = states(size(n.A,1));
    T = p_transition(n.A,S);
    p1 = p_state(y0s{neur},S);
    P = p_states(p1,T,Tmax);
    fp = 1 - P(1,1:max(dur));
end
figure
loglog(1:length(f),f,'.')
hold on
loglog(1:length(fp),fp)
hold off
clear x
%% c
figure
plot(sum(Y{find(dur>20,1)}))
