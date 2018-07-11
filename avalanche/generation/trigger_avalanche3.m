function Y_t = trigger_avalanche3(A, B, u_t, max_duration)
%trigger_avalanche - mostly vectorized
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t: input to system over time t, [N X t]
% returns
%   Y_t: neuron firing over time
%   max_duration: of avalanche

N = size(A,1); % number of neurons
Y_t = zeros(N, max_duration); % firing
u_t = padarray(u_t, [0 max_duration-size(u_t,2)], 'post');
% add zero padding to u_t

spikes_u = binornd(u_t(:,1), B);
Y_t(:,1) = spikes_u;
for t = 2 : max_duration
%     spikes_u = sum(binornd(u_t(:,t), B));
%     spikes_Y = sum(binornd(repmat(Y_t(:,t-1),[1 N]), A), 1);
%     Y_t(:,t) = spikes_u + spikes_Y;
    Y_t(:,t) = stochastic_spike_propagation(A,B,Y_t(:,t-1),u_t(:,t));
    if sum(Y_t(:,t)) == 0 && t >= size(u_t,2); break; end
end
Y_t = Y_t(:,1:t);

end
