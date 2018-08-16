function code = pop_code(Y)
%pop_code(Y) converts population code into a random variable
%   Y: [N X trial]
% returns
%   code: random variable that represents population code

code = joint(Y');

end

