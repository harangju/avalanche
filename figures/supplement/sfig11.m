%%
nets = load_emp_nets('/Users/harangju/Developer/data/cascade paper/ssc-3');
%%
msd = zeros(25, 1);
for i = 1:25
disp(i)
[~, res] = arres(nets{i}.w, nets{i}.A, nets{i}.v);
msd(i) = mean(res(:).^2);
end
%%
figure()
histogram(msd)
%%
mad = zeros(25, 1);
for i = 1:25
disp(i)
[~, res] = arres(nets{i}.w, nets{i}.A, nets{i}.v, 4);
mad(i) = mean(abs(res(:)));
end
%%
figure
histogram(mad)
prettify
xlabel('MAE')
ylabel('Number of recordings')
axis([-.01 .11 0 10])
%%
yit = [];
for i = 1:25
yit = [yit; unique(nets{i}.v(:))];
end
unique(yit)