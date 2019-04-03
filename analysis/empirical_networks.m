%% vector autoregression
data_dir = 'beggs data';
files = dir([data_dir '/*.mat']);
bin_size = 4;
ns = cell(1,length(files));
for i = length(files):-1:1
    disp(['Analyzing ' files(i).name '...'])
    load([data_dir '/' files(i).name]);
    ns{i} = net.generate('autoregressive',...
        'v',spike_times_to_bins(data.spikes,bin_size)',...
        'pmin',1,'pmax',4);
    ns{i}.v = [];
    save('emp_net_bs4')
end; clear i data
save('emp_net_bs4')
%% 
