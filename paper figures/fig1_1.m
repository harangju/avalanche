
%% generate wrg
rng(2)
p = default_network_parameters;
p.N = 10; p.N_in = 10;
p.frac_conn = 0.2;
p.graph_type = 'weightedrandom';
p.weighting = 'uniform'; p.weighting_params = 1;
p.critical_branching = false;
p.critical_convergence = true;
[A, B] = network_create(p);
figure(1); imagesc(A); colorbar; prettify
%%
figure(2); plot(graph_from_matrix(A))
%% webweb
for i=1:size(A,1)
    nodeNames{i} = ['node number ' num2str(i)];
end; clear i
webweb(A,nodeNames)
%% trigger_avalanches
dur = 15;
trials = 1e4;
[pats, probs] = pings_single(p.N);
[Y,order] = avl_smp_many(pats,probs,A,dur,trials);
%% 
X = avl_linear_many(pats,A,dur);
%%
colormap(flipud(gray))
%%
n=8;
figure(4)
imagesc(X{n}); colorbar; prettify
axis([0.5 11-.5 0.5 10.5]); title('linear')
%%
figure(3)
Y_n = avl_cell_to_mat(Y(order==n));
Y_n_avg = mean(Y_n,3);
imagesc(Y_n_avg); colorbar; prettify
axis([0.5 11-.5 0.5 10.5]); title('stochastic')
%%
df = Y_n_avg(Y_n_avg>0) - X{n}(Y_n_avg>0);
figure(5)
histogram(df,10); prettify; axis([-0.02 0.02 0 20])
[c,e] = histcounts(df,30);
%%
x = -.02 : 0.0001 : .02;
[muHat, sigmaHat] = normfit(df(:));
hold on
plot(x,normpdf(x,muHat,sigmaHat) * 0.2,'k')
hold off
%%
figure(6)
colormap(flipud(gray))
for i = 1 : 20
    imagesc(Y_n(:,:,i)); prettify
    saveas(gcf,['aval_' num2str(i)],'pdf')
    pause
end; clear i
%%
figure(7)
Y_n_avg_t = zeros(size(Y_n));
df_t = zeros(1,size(Y_n,3));
for i = 1 : size(Y_n,3)
    Y_n_avg_t(:,:,i) = mean(Y_n(:,:,1:i),3);
    yavg = Y_n_avg_t(:,:,i);
    df_t(i) = sum(X{n}(X{n}>0) - yavg(X{n}>0));
end
clear i yavg ylin
% plot(df_t,'Color',[3.1, 18.8, 42]/100)
plot(df_t,'k')
axis([0 1100 -.5 1.8])
prettify
