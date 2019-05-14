function code = pop_code_by_step(Y)
%pop_code_by_step maps network state at t to a #
%the set of #s reset for each t
%   Y: [N x duration x iterations]
%   code: [iterations x duration]

dur = size(Y,2);
iter = size(Y,3);
code = zeros(iter,dur);
for d = 1 : dur
    code(:,d) = joint(squeeze(Y(:,d,:))');
end

end

