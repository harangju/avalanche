function plot_avalanche(X_t, transitions)
%plot_avalanche Plots an avalanche
%   X_t: system state over time, [N X t]
%   transitions: cell array of transitions {1 X t}

marker_size_unit = 50;

N = size(X_t,1);
duration = size(X_t,2) - 1;

clf; hold on
for t = 1 : size(X_t, 2)
    X = X_t(:,t);
    X_idx = find(X);
    scatter(t*ones(size(X_idx)), X_idx, marker_size_unit * X(X_idx), ...
        'b', 'filled')
    % plot transitions
    if t > 1
        trans = transitions{t};
        width = size(trans, 1);
        for j = 1 : width
            plot([t-1 t], trans(j,:), 'k')
        end
    end
end
axis([0 floor(duration*1.2) 0 floor(N*1.2)]); 
axis square
title('avalanche'); xlabel('trial'); ylabel('neuron');
hold off; prettify

end
