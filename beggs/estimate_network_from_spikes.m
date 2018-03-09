function [A, te_pk, ci, te_pk_j, ci_j, filt] = ...
    estimate_network_from_spikes(data)
%estimate_network_from_spikes(data)
%   data: the data variable from Beggs datasets
% requires
%   te_matlab https://code.google.com/archive/p/transfer-entropy-toolbox/downloads

delays = 1:30;
filt_dim = [25 25]; filt_bounds = [-8 -2 0 1]; filt_thresh = 0.1;
disp('Preparing data...')
asdf = data.spikes;
asdf{end+2} = [data.nNeurons data.recordinglength];
disp('Jittering spike times...')
asdf_j = cellfun(@jitter, asdf(1:end-2), 'un', false);
asdf_j = cellfun(@bound_one, asdf_j, 'un', false);
asdf_j(end+1:end+2) = asdf(end-1:end);
disp('Calculating transfer entropy...')
disp('    actual data...')
tic; [te_pk, ci] = ASDFTE(asdf,delays); toc
disp('    of jittered data...')
tic; [te_pk_j, ci_j] = ASDFTE(asdf_j,delays); toc
disp('Removing autapses')
te_pk = te_pk - diag(diag(te_pk));
ci = ci - diag(diag(ci));
te_pk_j = te_pk_j - diag(diag(te_pk_j));
ci_j = ci_j - diag(diag(ci_j));
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
A = keep .* te_pk;

end

