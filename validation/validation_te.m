
%% load & setup
%   N: number of neurons
%   T: recording length in ms
%   spike_times: cell array of spike times

load('te_matlab_0.5/Izhik_100_0.mat')
spike_times = data.spikes;
N = data.nNeurons;
T = data.recordinglength;
filt_thresh = 0.1;

%% outputs
%   A:
%   te_pk:
%   ci:
%   te_pk_j:
%   ci_j:
%   filt:

%%
delays = 1:30;
filt_dim = [25 25]; filt_bounds = [-8 -2 0 1]; %filt_thresh = 0.1;
%% prepare data
disp('Preparing data...')
asdf = spike_times;
asdf{end+2} = [N T];
%% jitter spike times
disp('Jittering spike times...')
asdf_j = cellfun(@jitter, asdf(1:end-2), 'un', false);
asdf_j = cellfun(@bound_one, asdf_j, 'un', false);
asdf_j(end+1:end+2) = asdf(end-1:end);
%% calculate transfer entropy
disp('Calculating transfer entropy...')
disp('    actual data...')
tic; [te_pk, ci] = ASDFTE(asdf,delays); toc
disp('    of jittered data...')
tic; [te_pk_j, ci_j] = ASDFTE(asdf_j,delays); toc
%% remove autapses
disp('Removing autapses')
te_pk = te_pk - diag(diag(te_pk));
ci = ci - diag(diag(ci));
te_pk_j = te_pk_j - diag(diag(te_pk_j));
ci_j = ci_j - diag(diag(ci_j));
%% create filter with null distribution
disp('Creating filter...')
filt_dim = [25 25];
filt_bounds = [-8 -2 0 1];
edge_te_pk = linspace(filt_bounds(1),filt_bounds(2),filt_dim(1)+1);
edge_ci = linspace(filt_bounds(3),filt_bounds(4),filt_dim(2)+1);
n_j = histcounts2(log10(te_pk_j(:)),  ci_j(:),...
    edge_te_pk, edge_ci);
n = histcounts2(log10(te_pk(:)),  ci(:),...
    edge_te_pk, edge_ci);
filt = n_j ./ (n + n_j);
filt(isnan(filt)) = 0;
%% filter data
disp('Filtering data...')
keep = zeros(size(ci));
for i = 1 : asdf{end}(1)
    for j = 1 : asdf{end}(1)
        idx_ci = find(edge_ci < ci(i,j), 1, 'last');
        idx_te_pk = find(edge_te_pk < log10(te_pk(i,j)), 1, 'last');
        if filt(idx_te_pk, idx_ci) < filt_thresh
            keep(i,j) = 1;
        end
    end
end
disp('Done.')
%% 
A = keep .* te_pk;

