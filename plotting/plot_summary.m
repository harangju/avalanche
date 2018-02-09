function plot_summary(A, avalanche_sizes, avg_control, mod_control, ...
    ex_Y_t, ex_transition)
%plot_summary Plots a summary plot
%   A: network connectivity, [pre- X post-]
%   avalanche_sizes: vector of avalanche sizes
%   avg_control: average control of neurons
%   mod_control: modal control of neurons
%   ex_Y_t: example firing, see trigger_avalanche.m
%   ex_transition: example transition, see avalanche_transitions.m

subplot(2,2,1);
imagesc(A); title('connectivity')
set(gca,'YDir','normal')
xlabel('post-'); ylabel('pre-')
colorbar; axis square; prettify
drawnow

subplot(2,2,2)
[n_sizes, edges] = histcounts(avalanche_sizes);
bar(edges(2:end), n_sizes)
title('expected average avalanches')
xlabel('avalanche size'); ylabel('number of avalanches')
axis square; prettify
drawnow

subplot(2,2,3); hold on
% ave_c = ave_control(A);
[n_ave_c, e_ave_c] = histcounts(avg_control);
e_ave_c = e_ave_c(2:end);
plot(e_ave_c(n_ave_c>0), n_ave_c(n_ave_c>0), '-o')
% mod_c = modal_control(A);
[n_mod_c, e_mod_c] = histcounts(mod_control);
e_mod_c = e_mod_c(2:end);
plot(e_mod_c(n_mod_c>0), n_mod_c(n_mod_c>0), '-o')
legend({'average', 'modal'})
prettify; axis square; xlabel('controllability'); ylabel('number of neurons')
drawnow

subplot(2,2,4);
plot_avalanche(ex_Y_t, ex_transition)
title('example avalanche')
prettify; axis square; xlabel('time unit'); ylabel('neuron')
drawnow

end

