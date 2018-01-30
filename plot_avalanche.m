function plot_avalanche(avalanche, A)
%plot_avalanche Plots an avalanche

N = size(A,1);

clf; hold on
for i = 1 : length(avalanche)
    plot(i*ones(length(avalanche{i})), avalanche{i},...
        'b.', 'MarkerSize', 20)
    % plot lines
    if i < length(avalanche)
        for j = 1 : length(avalanche{i})
            current_node = avalanche{i}(j);
            for k = 1 : length(avalanche{i})
                next_nodes = find(A(current_node,:));
                for l = 1 : length(next_nodes)
                    plot([i i+1], [current_node next_nodes(l)], 'k')
                end
            end
        end
    end
end
title('avalanche')
axis([0 length(avalanche)+1 0 N+0.5]); axis square
xlabel('trial'); ylabel('neuron');
hold off; prettify

end
