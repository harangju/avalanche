function plot_network_on_mea(A, x, y)
%plot_network_on_mea(A, x, y) plots network in 2D MEA space
%   A: connectivity matrix
%   x: x-positions
%   y: y-positions

scatter(x, y, 'filled')
ax = [-1100 1100 -700 700];
hold on;
for i = 1 : size(A,1)
    for j = find(A(i,:))
        plot([x(i) x(j)], [y(i) y(j)], 'k')
    end
end
prettify; axis(ax)
xlabel('length of MEA'); ylabel('height of MEA')
hold off;

end

