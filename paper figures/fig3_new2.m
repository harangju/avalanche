
% many graph topologies
graphs = {'WRG','RG','MD4','WS'};
trials = 30;
% variables
H_m = cell(length(graphs),trials);
mi_pops = cell(length(graphs),trials);
max_ent = cell(length(graphs),trials);
f = zeros(length(graphs),trials);
% simulation parameters
dur=40; iter=1e3; scale = 5;
% loop
parfor g = 1 : length(graphs)
    for t = 1 : trials
        disp([graphs{g} ' ' num2str(t)])
        tic
        % generate graph
        p = default_network_parameters;
        p.num_nodes = 100;
        p.num_nodes_input = p.num_nodes;
        p.num_nodes_output = p.num_nodes;
        p.frac_conn = 0.1;
        p.graph_type = graphs{g};
        [A, B] = network_create(p);
        A = scale_weights_to_criticality(A);
        % stimulus patterns
        % eigendecomposition
        [v,d] = eig(A);
        d = diag(d);
        % make inputs with eigenvectors real, positive, & integers
        pats = cell(1,p.num_nodes);
        dups = 0;
        for i = 1 : p.num_nodes
            pats{i} = v(:,i);
            if ~isreal(d(i))
                if i < p.num_nodes &&...
                        abs(d(i)) == abs(d(i+1))
                    pats{i} = v(:,i) + v(:,i+1);
                elseif abs(d(i)) == abs(d(i-1))
                    pats{i} = v(:,i) + v(:,i-1);
                    dups = dups + 1;
                end
            end
            if find(pats{i}<0); pats{i} = -1 * pats{i}; end
            pats{i}(pats{i}<0) = 0;
            pats{i} = abs(pats{i});
            pats{i} = round(scale * pats{i});
        end
        % remove duplicates
        if sum(abs(pats{1} - pats{2})) > 1e-10
            d_real = d(1);
            pats_no_dup = pats(1);
        else
            d_real = [];
            pats_no_dup = {};
        end
        for i = 2 : length(pats)
            if sum(abs(pats{i-1} - pats{i})) > 1e-10
                pats_no_dup = [pats_no_dup pats{i}];
                d_real = [d_real abs(d(i))];
            end
        end
        pats = pats_no_dup;
        % simulation
        mi_pops{g,t} = zeros(length(pats), dur);
        max_ent{g,t} = zeros(1,length(pats));
        for i = 1 : length(pats)
%             disp([num2str(i) '/' num2str(length(pats))])
            probs = 0.5*ones(1,length(pats))/(length(pats)-1);
            probs(i) = 0.5;
%             tic
            [Y,pat] = trigger_many_avalanches(A, B, pats, probs, dur, iter);
%             toc
            pa = pat';
            pa(pat==i) = 1;
            pa(pat~=i) = 2;
            mi_pops{g,t}(i,:) = mutual_info_pop(Y,pa);
            max_ent{g,t}(i) = h(pa);
        end
        % predictor
        H = zeros(length(pats),dur);
        for i = 1 : length(pats)
            H(i,:) = avalanche_predictor(A,pats{i},dur);
        end
        H_m{g,t} = mean(H.*(1:dur),2);
        H_m{g,t}(isnan(H_m{g,t})) = 0;
        toc
        % get p values
    end
end

%% plot individual surface plots
g = 1;
t = 1;
[H_m_sort,idx] = sort(H_m{g,t});
surf(1:dur,H_m_sort,mi_pops{g,t}(idx,:),'LineWidth',0.25)
prettify; axis vis3d;
% xlabel('time'); ylabel('H'); zlabel('MI')
set(gca,'LineWidth',.75);
clear H_m_sort idx g t

%% 
decay_mi = cell(size(H_m));
decay_h = zeros(size(H_m));
for g = 1 : length(graphs)
    for t = 1 : trials
        num_pats = size(mi_pops{g,t},1);
        decay_mi{g,t} = zeros(1,num_pats);
        for p = 1 : num_pats
            f = polyfit(1:dur,mi_pops{g,t}(p,:),1);
            decay_mi{g,t}(p) = f(1);
        end
        [H_m_sort,idx] = sort(H_m{g,t});
%         f = polyfit(H_m_sort',decay_mi{g,t}(idx),1);
        r = corr(H_m_sort,decay_mi{g,t}(idx)');
        decay_h(g,t) = r;
    end
end
clear g t p num_pats H_m_sort idx fr

%% plot
boxplot(decay_h','Colors','k')
prettify; axis fill
h = findobj(gcf,'tag','Outliers');
for iH = 1:length(h)
    h(iH).MarkerEdgeColor = [0 0 0];
end
clear h iH
axis([.5 4.5 0 1])


%% plot methods
g = 1;
t = 1;
scatter(H_m{g,t},decay_mi{g,t},'.k')
f = polyfit(H_m{g,t},decay_mi{g,t}',1);
hold on
x = min(H_m{g,t}) : 1e-2 : max(H_m{g,t});
plot(x,polyval(f,x),'r')
hold off
prettify
clear g t x
