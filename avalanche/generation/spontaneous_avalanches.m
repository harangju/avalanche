function Y = spontaneous_avalanches(A, B, prob, iter)
%spontaneous_avalanches(A, B, prob) gives each node Pr(fire) = prob for
%iter iterations

N = size(A,1);
Y = zeros(N, iter);

zero_input = zeros(length(B),1);
Y(:,1) = rand(N,1) < prob;
for t = 2 : iter
    y_spont = rand(N,1) < prob;
    Y(:,t) = Y(:,t) + y_spont;
    Y(:,t) = Y(:,t) +...
        stochastic_spike_propagation(A, B, Y(:,t-1), zero_input);
%     Y(:,t) = double(Y(:,t) > 0);
end

end
