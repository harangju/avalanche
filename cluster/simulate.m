%% spontaneous activity
p_spike = 1e-5;
iter = 1e4;
tic
Y = spontaneous_avalanches(A,B,p_spike,iter);
toc
