
%% data path
path='~/Desktop/20180525_134819/';
%%
size_aval = @(a) sum(sum(a,2)>0);
n_bins = 30;
%%
d = dir(path);
% fits_size = cell(1,length(d)-2);
% errors_size = cell(1,length(d)-2);
% fits_dur = cell(1,length(d)-2);
% errors_dur = cell(1,length(d)-2);
% aval_durs = 
% c = 1;
aval_durs = cell(1,length(d)-2);
aval_sizes = cell(1,length(d)-2);
for i = 1:length(d)
    folder = d(i).name;
    if folder(1) == '.'; continue; end
    dat = load([path folder '/matlab.mat']);
    Y = dat.Y;
    disp([path folder '/matlab.mat'])
    tic
    aval = find_avalanches(Y);
    aval_durs{i-2} = cellfun(@size,aval, num2cell(2*ones(1,length(aval))));
%     subplot(2,1,1)
%     [n,edges] = histcounts(aval_durs, n_bins);
%     plot(log10(edges(1:end-1)),log10(n)/length(aval),'-*')
%     prettify; xlabel('avalanche duration log_{10}'); ylabel('probability')
%     [fits_size{c}, errors_size{c}] = power_law_fit(edges(2:end),n);
    aval_sizes{i-2} = cellfun(size_aval, aval);
%     [n,edges] = histcounts(aval_sizes, n_bins);
%     subplot(2,1,2)
%     plot(log10(edges(1:end-1)),log10(n)/length(aval),'-*')
%     prettify; xlabel('avalanche size log_{10}'); ylabel('probability')
%     [fits_dur{c}, errors_dur{c}] = power_law_fit(edges(2:end),n);
%     c = c + 1;
%     pause
end; clear i
%%
save('aval_dat')

