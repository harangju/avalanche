function A = weights_bound(A, bound_lower, bound_upper)
%weights_bound 

min_A = min(A(:));
max_A = max(A(:));
% if min_A < bound_lower
%     A = A - min_A;
% end
A(A<bound_lower) = bound_lower;
if max_A > bound_upper
    A = A ./ max_A .* bound_upper;
end

end

