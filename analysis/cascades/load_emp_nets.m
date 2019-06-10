function nets = load_emp_nets(emp_data_dir)
% nets = load_emp_nets(emp_data_dir)
%   returns networks derived from empirical data (see Rload_emp_netsEADME).
%   The function first checks to see if there is a file called 'emp_nets'
%   in the environment. If there isn't, it derives a network from empirical
%   data & saves to 'emp_nets'.

bin_size = 5;
pmax = 1;

emp_nets_filename = 'emp_nets.mat';
if exist(emp_nets_filename,'file') == 2
    data = load(emp_nets_filename);
    nets = data.nets;
else
    files = dir([emp_data_dir '/*.mat']);
    nets = cell(length(files),1);
    for i = 1 : length(files)
        disp(['Analyzing ' files(i).name '...'])
        x = load([emp_data_dir '/' files(i).name]);
        data = x.data;
        nets{i} = net.generate('autoregressive',...
            'v',spike_times_to_bins(data.spikes,bin_size)',...
            'pmin',1,'pmax',pmax);
        nets{i}.v = [];
        nets{i}.A = sum(nets{i}.A,3);
    end
    save(emp_nets_filename)
end
