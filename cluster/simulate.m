%% spontaneous activity
p_spike = 1e-4;
iter = 1e6;
tic
Y = spontaneous_avalanches(A,B,p_spike,iter);
toc
