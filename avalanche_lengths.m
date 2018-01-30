function lengths = avalanche_lengths(A, B)
%count_avalanches counts # and lengths of avalanches in network
%   that originate from single neuron

N = size(A,1);
lengths = zeros(N,1);

for i = 1 : N
    lengths(i) = length(find_avalanche(A,B,i));
end

end

