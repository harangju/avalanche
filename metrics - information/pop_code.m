function code = pop_code(Y, nodes)
%pop_code(Y) converts population code into a random variable
%   Y: [N X t X trial]
%   nodes: subset of neurons to use
% returns
%   code: random variable that represents population code, [t X trial]

code = zeros(size(Y,2), size(Y,3));
for i = 1 : size(Y,2)
    code(i,:) = joint(squeeze(Y(nodes,i,:))');
end

end

