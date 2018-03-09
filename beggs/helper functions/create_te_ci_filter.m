function filt = create_te_ci_filter(te_pk, ci, ...
    te_pk_j, ci_j, filt_dim, filt_bounds)
%create_te_ci_filter(...) creates a filter based on jittered TE and CI
%   te_pk: actual peak TE
%   ci: actual CI
%   te_pk_j: jittered peak TE
%   ci_j: jittered CI
%   filt_dim: [rows columns]
%   filt_bounds: [left right bottom top]
edge_te_pk = linspace(filt_bounds(1),filt_bounds(2),filt_dim(1)+1);
edge_ci = linspace(filt_bounds(3),filt_bounds(4),filt_dim(2)+1);
n_j = histcounts2(log10(te_pk_j(:)),  ci_j(:),...
    edge_te_pk, edge_ci);
n = histcounts2(log10(te_pk(:)),  ci(:),...
    edge_te_pk, edge_ci);
filt = n_j ./ (n + n_j);
filt(isnan(filt)) = 0;
end

