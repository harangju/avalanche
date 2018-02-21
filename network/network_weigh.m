function A = network_weigh(A, type, params, exp_branching, degree)
%network_weigh Returns a weighted network
%   called by network_create

switch type
    case 'G' % gaussian
%         mu = params(1);
        sigma = params(2);
        mu = desired_mean_weight(exp_branching, degree);
        if mu < 3*sigma
            sigma = mu/3;
        end
        A = weigh_normal(A, mu, sigma);
    case 'PL' % power law
        A = weigh_power(A);
    case 'SC' % streamline counts
        warning('create_network(): streamline counts not implemented')
    case 'FA' % fractional anistropy
        warning('create_network(): fractional anistropy not implemented')
    otherwise
        warning('create_network(): undefined weighting')
end
end

