%% load
% to derive from scratch, run fig4_i
% load('')
%% sfig5 - examples
figure
j = 4;
% [~,i] = max(ce_r_fd(:,j));
i = 16;
clf
plot(firs_x0_emp{i,j},durs_emp{i},'k.')
disp(i)
% axis([1 1.07 0 1500])
prettify
clear i j