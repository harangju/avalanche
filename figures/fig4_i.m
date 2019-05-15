%% load network
% basedir = ''; % directory of empirical netowworks
load([basedir '/emp_bs2.mat'])
%% detect avalanches
data_dir = 'beggs data';
files = dir([data_dir '/*.mat']);
bin_size = 2;
av_emp = cell(1,length(ns));
for i = length(files):-1:1
    disp(['Analyzing ' files(i).name '...'])
    load([data_dir '/' files(i).name]);
    bins = spike_times_to_bins(data.spikes,bin_size);
    av_emp{i} = detect_avalanches(bins);
    clear bins data
end
clear i
%% calculate finite impulse response
T = 100;
firs_emp = cell(1,length(ns));
for i = 1 : length(ns)
    firs_emp{i} = finite_impulse_responses(sum(ns{i}.A,3),T);
end
clear i
%% controllability of x0
ce_fd_tb = 1:10;
firs_x0_emp = cell(length(ns),length(ce_fd_tb));
for i = 1 : length(av_emp)
    for j = 1 : length(ce_fd_tb)
        firs_x0_emp{i,j} = zeros(1,length(av_emp{i}));
        for k = 1 : length(av_emp{i})
            ts = min(ce_fd_tb(j), size(av_emp{i}{k},2) );
            active = sum(av_emp{i}{k}(:,1:ts),2)>0;
            firs_x0_emp{i,j}(k) = sum(firs_emp{i}(active))/sum(active);
        end
    end
    clear ts active
end
clear i j k
%% calculate correlations
ce_p_fd = zeros(length(ns),length(ce_fd_tb));
ce_r_fd = zeros(length(ns),length(ce_fd_tb));
for i = 1 : length(ns)
    for j = 1 : length(ce_fd_tb)
        [ce_r_fd(i,j),ce_p_fd(i,j)] =...
            corr(firs_x0_emp{i,j}',durs_emp{i}','Type','Spearman');
    end
end
clear i
disp([ce_r_fd ce_p_fd])
disp(mean(ce_r_fd,1))
%% fig4i
figure
clf
hold on
boxplot(ce_r_fd)
plot(ce_fd_tb, ce_r_fd, 'k.')
prettify
% axis([.5 4.5 -.05 .5])
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

