function A = network_weigh(A, type, parameters)
%network_weigh Returns a weighted network
%   called by network_create

switch type
    case 'G' % gaussian
        mu = parameters(1);
        sigma = parameters(2);
%         mu = desired_mean_weight(p.exp_branching, p.frac_conn, p.num_nodes);
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

