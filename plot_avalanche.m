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
        for j = 1 : width
            plot([i-1 i], avalanche{i}(j,:), 'k')
        end
    end
end
title(['avalanche from anchor(s): ' num2str(avalanche{1}(:,2)')])
% axis([0 length(avalanche)+1 0 N]); 
axis square
xlabel('trial'); ylabel('neuron');
hold off; prettify

end
