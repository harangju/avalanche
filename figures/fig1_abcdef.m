%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig1_abcdef.mat'])
else
    disp('Generating network...')
    n = net.generate('erdosrenyi','n',10,'p',0.2,'dir',true);
    n.A = n.A./sum(n.A,1);
    n.A(isnan(n.A)) = 0;
    disp('Simulating...')
    K = 1e5;
    Tmax = 15;
    [y0s,p_y0s] = pings_single(size(n.A,1));
    [Y,i_y0s] = simulate(@smp,n.A,y0s,Tmax,p_y0s,K);
    neur = 8;
    Y_n = Y(i_y0s==neur);
    idx = [8 1 20 2];
    disp('Calculating linear dynamics...')
    X = simulate(@linear,n.A,y0s,Tmax);
    disp('Calculating convergence...')
    Y_n_mat = csc_cell_to_mat(Y_n);
    Y_n_avg_t = zeros(size(Y_n_mat));
    df_t = zeros(1,length(Y_n));
    for i = 1 : length(Y_n)
        Y_n_avg_t(:,:,i) = mean(Y_n_mat(:,:,1:i),3);
        yavg = Y_n_avg_t(:,:,i);
        df_t(i) = sum(X{neur}(X{neur}>0) - yavg(X{neur}>0));
    end
    clear i yavg
end
%% fig1a
% use webweb to generate graph (https://github.com/dblarremore/webweb)
%% fig1b
figure
for i = 1 : length(idx)
    subplot(1,length(idx),i)
    imagesc(Y_n{idx(i)})
end
clear i
title('b')
%% fig1c
Y_n_avg = mean(csc_cell_to_mat(Y_n),3);
figure
imagesc(Y_n_avg)
title('c')
%% fig1d
if ~exist('basedir','var')
    
end
figure
imagesc(X{neur})
title('d')
%% fig1e
figure
plot(df_t,'k')
axis([0 1100 -.5 1.8])
prettify
%% fig1f
df = Y_n_avg(Y_n_avg>0) - X{neur}(Y_n_avg>0);
figure
histogram(df,10); prettify; axis([-0.02 0.02 0 20])
