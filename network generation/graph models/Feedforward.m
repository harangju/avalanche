function A = Feedforward(neurons_per_layer,...
    frac_conn_per_layer)
%Feedfoward

num_layers = length(neurons_per_layer);
num_neurons = sum(neurons_per_layer);

A = zeros(num_neurons, num_neurons);

layer_idx = 1;
for l = 1 : num_layers-1
    num_conn = frac_conn_per_layer(l) * neurons_per_layer(l+1);
    for n = 1 : neurons_per_layer(l)
        conn = randperm(neurons_per_layer(l+1), num_conn);
        neuron_i = (layer_idx + n - 1) * ones(1,num_conn);
        neuron_j = layer_idx + neurons_per_layer(l) + conn - 1;
        A(neuron_i, neuron_j) = 1;
    end
    layer_idx = layer_idx + neurons_per_layer(l);
end

end

