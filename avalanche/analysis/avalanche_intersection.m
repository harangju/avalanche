function [nodes,times] = avalanche_intersection(A, B, u_t1, u_t2,...
    max_duration)
%avalanche_intersection Finds nodes & times at which avalanches intersect
%   avalanches triggered by u_t1 & u_t2
%   A: system connectivity, [pre X post]
%   B: system input connectivity, [input X N]
%   u_t1: input to system over time t, [N X t]
%   u_t2: another input
% returns
%   nodes: node indices
%   times: time indices

X1 = avalanche_average_analytical(A,B,u_t1,max_duration);
X2 = avalanche_average_analytical(A,B,u_t2,max_duration);
X = (X1>0) & (X2>0);
[nodes, times] = find(X);

end

