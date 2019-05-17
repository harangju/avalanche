%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig3_a.mat'])
else
    % acyclic 3-node graph
    Aa = [0 .5 0; 0 0 .5; 0 0 0];
    % cyclic 3-node graph
    Ac = [0 .5 0; 0 0 .5; 0.5 0 0];
    % simulation
    [y0s,p_y0s] = pings_single(3);
    T = 1e4;
    K = 1e6;
    disp('Simulating acyclic graph...')
    [Ya,ia_y0s] = simulate(@smp,Aa,y0s,T,p_y0s,K);
    disp('Simulating cyclic graph...')
    [Yc,ic_y0s] = simulate(@smp,Ac,y0s,T,p_y0s,K);
    % analysis
    dur_a = csc_durations(Ya);
    dur_c = csc_durations(Yc);
end
%% fig3a
colors = linspecer(2);
figure
x = unique(dur_a);
y = histcounts(dur_a,[x max(x)+1]);
loglog(x,y/sum(y),'s','Color',colors(1,:),'MarkerSize',7)
hold on
x = unique(dur_c);
y = histcounts(dur_c,[x max(x)+1]);
loglog(x,y/sum(y),'.','Color',colors(2,:),'MarkerSize',10)
prettify
xlim([10^0 10^2])
legend({'acyclic','cyclic'})
clear x y