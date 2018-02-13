function plot_avalanche(X_t, transitions)
%plot_avalanche Plots an avalanche
%   X_t: system state over time, [N X t]
%   transitions: cell array of transitions {1 X t}

marker_size_unit = 80;
color_input = .8;
color_active = .2;

N = size(X_t,1);
duration = size(X_t,2);

g = zeros(1, duration);

for t = 1 : duration
    X = X_t(:,t);
    trans = transitions{t};
    % plot active neurons
    X_idx = find(X);
    colors = color_active * ones(size(X_idx));
    if t == 1
        colors(:) = color_input;
    else
        colors(~ismember(X_idx, trans(:,2))) = color_input;
    end
    g(t) = scatter(t*ones(size(X_idx)), X_idx, ...
        marker_size_unit * X(X_idx), colors, 'filled');
    hold on
    % plot transitions
    for j = 1 : size(trans,1)
        plot([t-1 t], trans(j,:), 'k')
    end
end
axis([0 floor((duration+1)*1.1) 0 floor(N*1.1)]); axis square
title('avalanche'); xlabel('time'); ylabel('neuron');
hold off; prettify; colormap jet; caxis([0 1])
legend(g(1:2), {'input', 'activated'})

end
