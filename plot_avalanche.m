function plot_avalanche(avalanche, N)
%plot_avalanche Plots an avalanche
%   avalanche: cell array of transitions

clf; hold on
for i = 1 : length(avalanche)
    width = size(avalanche{i}, 1);
    plot(i*ones(width, 1), avalanche{i}(:, 2),...
        'b.', 'MarkerSize', 20)
    % plot lines
    if i > 1
        plot(repmat([i-1 i], [1 width]),...
            reshape(avalanche{i}', [1 width*2]), 'k')
    end
end
title('avalanche')
axis([0 length(avalanche)+1 0 N+0.5]); axis square
xlabel('trial'); ylabel('neuron');
hold off; prettify

end
