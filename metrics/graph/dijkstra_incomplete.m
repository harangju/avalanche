function [cost, route] = dijkstra(A,s,t)
%dijkstra Performs Dijkstra's shortest path algorithm
%   Adjacency matrix A is directed, rows to columns
%
%   Example:
%       A = [0 1 0; 0 0 1; 1 0 0];
%       [cost, route] = dijkstra(A,1,3);
%           cost = 2, route = [1 2 3]
%   
%   based on https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
%

N = size(A,1);

% initialization
dist = [];
prev = [];
Q = {};
for i = 1 : N
    for j = 1 : N
        if A(i,j) > 0
            dist = [dist inf];
            prev = [prev nan];
            Q = [Q [i,j]];
        end
    end
end



end

