function resp = finite_impulse_response(A,B,T)
%finite_impulse_response(A,B,T)
%   A: source X target weight matrix
%   B: input matrix
%   T: max iteration
%returns
%   resp: response of B

Wk = 0; % finite controllability Gramian
for t = 0 : T
    Wk = Wk + (A^t*B)*(B'*A'^t);
end

resp = trace(Wk);

end