function cycles = find_struct_cycles(A)
% c = find_struct_cycles(A)
%   returns the simple cycles, cycles, in the network adjacency matrix A
%   uses python & networkx
py.importlib.import_module('networkx');
clear ans
g = py.networkx.DiGraph();
for i = 1 : size(A,1)
    for j = 1 : size(A,2)
        if A(i,j) > 0
            g.add_edge(j,i);
        end
    end
end
cycles = cell(py.list(py.networkx.simple_cycles(g)));
