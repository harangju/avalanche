%% analyze
activity = squeeze(sum(Y,1))';
durations = zeros(1,iter);
for j = 1 : iter
    if sum(activity(j,:)) > 0
        durations(j) = find(activity(j,:)>0,1,'last');
    else
        durations(j) = 0;
    end
end
[c_d,e_d,bin_idx] = histcounts(durations,100);
x = log10(e_d(2:end));
y = log10(c_d/(sum(c_d)));
x(isinf(y)) = [];
y(isinf(y)) = [];
x(y==0) = [];
y(y==0) = [];

