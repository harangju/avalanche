function plot_network(A)
%plot_network

g = graph_from_matrix(A);
plot(g, 'MarkerSize', 5)
title('graph')
axis square; axis off
prettify

end

