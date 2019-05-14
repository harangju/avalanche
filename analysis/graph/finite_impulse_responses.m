function resp = finite_impulse_responses(A,T)
%finite_impulse_responses(A,B,T)
%   A: source X target weight matrix
%   T: max iteration
%returns
%   resp: response of individual nodes

N = size(A,1);
resp = zeros(N,1);
for n = 1 : N
    B = zeros(N,1);
    B(n) = 1;
    resp(n) = finite_impulse_response(A,B,T);
end

end