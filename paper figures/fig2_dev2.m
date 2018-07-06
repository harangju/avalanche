% many graph topologies
graphs = {'WRG','RG','MD4','WS'};
trials = 30;
% variables
H_m = cell(length(graphs),trials);
dur_mean = cell(length(graphs),trials);
r = zeros(length(graphs),trials);
% stimulus patterns
input_activity = 0.1;
pat_num = 100;
num_nodes = 100;
pats = cell(1,pat_num);
for i = 1 : pat_num
    pats{i} = double(rand(num_nodes,1) < input_activity);
end; clear i
% simulation parameters
dur = 300; iter = 3e3;
% loop
for g = 1 %: length(graphs)
    for t = 1 %: trials
        disp([graphs{g} ' ' num2str(t)])
        % generate graph
        p = default_network_parameters;
        p.num_nodes = 100;
        p.num_nodes_input = p.num_nodes;
        p.num_nodes_output = p.num_nodes;
        p.frac_conn = 0.1;
        p.graph_type = graphs{g};
        [A, B, C] = network_create(p);
        A = scale_weights_to_criticality(A);
        % simulation
        probs = ones(1,length(pats)) / length(pats);
        tic; [Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
        toc; beep
        activity = squeeze(sum(Y,1))';
        % predicted
        Yp = zeros(p.num_nodes,dur,length(pats));
        for i = 1 : length(pats)
            Yp(:,:,i) = avalanche_average_analytical(A,B,pats{i},dur);
        end
        % measure duration
        durs = zeros(1,iter);
        for i = 1 : iter
            if sum(activity(i,:)) > 0
                durs(i) = find(activity(i,:)>0,1,'last');
            else
                durs(i) = 0;
            end
        end
        % mean duration
        dur_mean{g,t} = zeros(1,length(pats));
        for i = 1 : length(pats)
            dur_mean{g,t}(i) = mean(durs(pat==i));
        end
        % predictor
        H = zeros(length(pats),dur);
        for i = 1 : length(pats)
            H(i,:) = avalanche_predictor(A,pats{i},dur);
        end
        H_m{g,t} = mean(H.*(1:dur),2);
        H_m{g,t}(isnan(H_m{g,t})) = 0;
        r(g,t) = corr(H_m{g,t},dur_mean{g,t}');
        % get p values
    end
end

%% plot
boxplot(r','Colors','k')
prettify
axis fill
axis([0.5 4.5 0 1])
h = findobj(gcf,'tag','Outliers');
for iH = 1:length(h)
    h(iH).MarkerEdgeColor = [0 0 0];
end



