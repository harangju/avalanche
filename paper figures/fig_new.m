%% empirical data
data_dir = 'beggs data';
files = dir([data_dir '/*.mat']);
bin_size = 2;
for i = 7:-1:1 %length(files):-1:1
    disp(['Analyzing ' files(i).name '...'])
    load([data_dir '/' files(i).name]);
    ns(i) = net.generate('topology','autoregressive',...
        'v',spike_times_to_bins(data.spikes,bin_size)',...
        'pmin',1,'pmax',4);
    ns(i).v = [];
end; clear i data
%%
