function prettify
%prettify makes figures pretty

box off;
set(gca,'FontSize',16);
% set(gca,'LineWidth',2);
set(gca,'LineWidth',0.75);
set(gca,'TickDir','out');
axis square;

end

