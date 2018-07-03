


%% Beggs
load('beggs data/DataSet2.mat')
%% create subnetwork
deg = outdegree(A) + indegree(A);
A = A(deg>0,deg>0);
p.num_nodes = size(A,1);
B = ones(p.num_nodes,1);
%% WRG
p = default_network_parameters;
p.num_nodes = 100;
p.num_nodes_input = 100;
p.frac_conn = 0.1;
p.graph_type = 'WRG';
%% RG
p.graph_type = 'RG';
%% generate graphs
A = network_create(p);
A = scale_weights_to_criticality(A);
B = ones(p.num_nodes,1);
%% make full rank
[r,ri_c] = rref(A);
[r,ri_r] = rref(A');
imagesc(r); colorbar
disp(length(ri_c))
A = A(ri_r,ri_c);
disp(rank(A))
%% reset params
p.num_nodes = length(ri_c);
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
A = scale_weights_to_criticality(A);
B = ones(p.num_nodes,1);
C = ones(p.num_nodes,1);

%% check connectivity
disp(mean(A(:)>0))
%%
imagesc(A)
prettify; axis square; colorbar
%% make stimulus patterns
input_activity = 0.1;
pat_num = 40;
pats = cell(1,pat_num);
for i = 1 : pat_num
    pats{i} = rand(p.num_nodes,1) < input_activity;
end; clear i

%% eigendecomposition
[v,d] = eig(A);
d = diag(d);

%% make inputs with eigenvectors real, positive, & integers
scale = 5;
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
end; clear i
%% remove duplicates
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
end; clear i
pats = pats_no_dup;

%% try all eigenvectors
dur=40; iter=1e3;
mi_pops = zeros(length(pats), dur);
max_ent = zeros(1,length(pats));
for i = 1 : length(pats)
    disp([num2str(i) '/' num2str(length(pats))])
    probs = 0.5*ones(1,length(pats))/(length(pats)-1);
    probs(i) = 0.5;
    tic
    [Y,pat] = trigger_many_avalanches(A, B, pats, probs, dur, iter);
    toc
    pa = pat';
    pa(pat==i) = 1;
    pa(pat~=i) = 2;
    mi_pops(i,:) = mutual_info_pop(Y,pa);
    max_ent(i) = h(pa);
end; clear i

%% predictor
H = zeros(length(pats),dur);
for i = 1 : length(pats)
    H(i,:) = avalanche_predictor(A,pats{i},dur);
end; clear i
H_m = mean(H.*(1:dur),2);
H_m(isnan(H_m)) = 0;

%% plot surface
colormap parula
clf
[H_m_sort,idx] = sort(H_m);
surf(1:dur,H_m_sort,mi_pops(idx,:),'LineWidth',0.25)
prettify; axis vis3d; %axis([0 dur+1 0 1 0 1]); 
xlabel('time'); ylabel('H'); zlabel('MI')
set(gca,'LineWidth',.75);
%% plot individual lines
clf; hold on
% is = [1 26 80]; % wrg200
% is = [1 105 180]; % rg200
% is = [1 6 50]; % beggs1
is = 1:p.num_nodes;
lineStyles = linspecer(length(is));
colormap(linspecer)
plts = zeros(1,length(is));
for i = 1 : length(is)
    j = is(i);
    plts(i) = plot(mi_pops(idx(j),:),'LineWidth',1);
end; clear i j
prettify
axis([0 35 0 1])
legend(plts, {...
    ['\lambda=' num2str(d_real(idx(is(1))))],...
    ['\lambda=' num2str(d_real(idx(is(2))))],...
    ['\lambda=' num2str(d_real(idx(is(3))))]},...
    'FontSize',18);
set(gca,'LineWidth',.75);




