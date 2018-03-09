function plot_filtering(A, te_pk, ci, te_pk_j, ci_j, filt)
%plot_filtering(...)
%   see estimate_network_from_spikes

subplot(2,2,1)
scatter(log10(te_pk(:)),ci(:),'.')
prettify; axis square; title('actual')
subplot(2,2,2)
scatter(log10(te_pk_j(:)),ci_j(:),'.')
prettify; axis square; title('jittered')
subplot(2,2,3)
scatter(log10(te_pk(A>0)),ci(A>0),'.')
prettify; axis square; title('separation');
axis([-8 -2 0 1])
subplot(2,2,4)
imagesc(filt')
prettify; axis square; title('filter'); set(gca,'YDir','normal');
colormap gray; colorbar
subplot(2,2,4)

end

