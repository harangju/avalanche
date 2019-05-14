function r = finite_impulse_responses_input(A,I,T)
%finite_impulse_responses_input(A,T,I)
%
%   Parameters:
%       A: source X target weight matrix
%       I: input matrix of vectors
%       T: max iteration
%
%   Returns:
%       r: impulse response of inputs from I

num_inputs = size(I,2);
r = zeros(num_inputs,1);
for i = 1 : num_inputs
    r(i) = finite_impulse_response(A,I(:,i),T);
end

end

