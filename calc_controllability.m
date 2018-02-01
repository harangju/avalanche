function c = calc_controllability(A, B, type)
%calc_controllability Calculates controllability
%   Options:
%       'global'
%       'modal'
%       'boundary'

c = 0;

switch type
    case 'global'
        
    case 'modal'
        
    case 'boundary'
        
    otherwise
        error('Invalid type.')
end

end

