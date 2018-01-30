function plot_network(A)
%plot_network

N = size(A,1);
source = mod(find(A),N);
source(source==0) = N;
target = repelem(1:N, sum(A))';
g = digraph(source,target);
plot(g, 'MarkerSize', 5)
title('graph')
axis square; axis off
prettify

end

