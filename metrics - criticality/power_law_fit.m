function [p, s] = power_law_fit(x,y)
%power_law_fit(x,y)
%   x: one thing
%   y: another thing

if size(x,1)==1; x=x'; end
if size(y,1)==1; y=y'; end

[p, s] = fit(x, y, 'power1');

end

