function durations = avalanche_duration(A, B)
%avalanche_duration durations of avalanches in network
%   that originate from single neuron

N = size(A,1);
durations = zeros(N,1);

for i = 1 : N
    durations(i) = length(find_expected_avalanche(A,B,i));
end

end

