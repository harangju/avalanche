function A_scaled = scale_weights_to_criticality(A)
%scale_weights_to_criticality

%A_scaled = A ./ branching(A);
A_scaled = A ./ repmat(branching(A), [1 size(A,2)]);
A_scaled(isnan(A_scaled)) = 0;

end

