

nodes = [2 4 8 16 32 64];
conn = [0.3 0.1 0.03 0.01 0.003];
% graph = {'WRG' 'RL' 'WS' 'MD2' 'MD4' 'MD8' 'RG' 'BA'};
graph = {'WRG' 'RG' 'BA'};
branch = [0.2 0.6 1.0 1.4 1.8 2.2 2.6];
mi_mean = zeros(length(nodes),length(conn),length(graph),...
    length(branch));
mi_top = zeros(size(mi_mean));
mi_min = zeros(size(mi_mean));
mi_std = zeros(size(mi_mean));
mi_time = zeros(size(mi_mean));


