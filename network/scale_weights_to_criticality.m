function A_scaled = scale_weights_to_criticality(A)
%scale_weights_to_criticality

A_scaled = A ./ branching(A);

end

