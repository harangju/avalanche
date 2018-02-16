function A = weights_bound(A, min, max)
%weights_bound 

min_A = min(A(:));
max_A = max(A(:));
if min_A < min
    A = A - min_A;
end
if max_A > max
    A = A ./ max_A .* max;
end

end

