
load('avalanche/example networks/network_wrg_n1e2_p2e-3_k99_2.mat')
%%
X_t = avalanche_average_analytical(A,B,u_t,1e2);
trans_emp = avalanche_transitions(X_t, A);
Y_t_avg = avalanche_average_empirical(A, B, u_t, 1e3, 1e2);
trans_avg = avalanche_transitions(Y_t_avg, A);
%% plot
clf
subplot(2,2,1); plot_avalanche(X_t, trans_emp)
title('analytical average avalanche')
subplot(2,2,2); imagesc(X_t); colorbar; axis square; prettify;
xlabel('time'); title('analytical'); set(gca, 'YDir', 'normal')
subplot(2,2,3); plot_avalanche(Y_t_avg, trans_avg)
title('empirical average avalanche')
subplot(2,2,4); imagesc(Y_t_avg); colorbar; axis square; prettify;
xlabel('time'); title('empirical'); set(gca, 'YDir', 'normal')
