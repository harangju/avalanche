


%% Beggs
load('beggs data/DataSet2.mat')
%% create subnetwork
deg = outdegree(A) + indegree(A);
A = A(deg>0,deg>0);
params.num_nodes = size(A,1);
B = ones(params.num_nodes,1);
%% WRG
params = default_network_parameters;
params.num_nodes = 169;
params.num_nodes_input = 169;
params.frac_conn = 0.0098;
params.graph_type = 'WRG';
%% RG
params.graph_type = 'RG';
%% generate graphs
A = network_create(params);
A = scale_weights_to_criticality(A);
B = ones(params.num_nodes,1);

%% eigendecomposition
[v,d] = eig(A);
d = diag(d);
%% check connectivity
disp(mean(A(:)>0))
%%
imagesc(A)
prettify; axis square; colorbar
%% eigenvalues
bar(d); prettify
%% dominant eigenvector
bar(v(:,1)); prettify
%% make inputs with eigenvectors real, positive, & integers
scale = 5;
pats = cell(1,params.num_nodes);
dups = 0;
% d_real = [];
for i = 1 : params.num_nodes
    pats{i} = v(:,i);
    if ~isreal(d(i))
        if i < params.num_nodes &&...
                abs(d(i)) == abs(d(i+1))
            pats{i} = v(:,i) + v(:,i+1);
        elseif abs(d(i)) == abs(d(i-1))
            pats{i} = v(:,i) + v(:,i-1);
            dups = dups + 1;
%             d_real = [d_real d(i)+d(i-1)];
        end
    else
%         d_real = [d_real d(i)];
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
end
for i = 2 : length(pats)
    if sum(abs(pats{i-1} - pats{i})) > 1e-10
        pats_no_dup = [pats_no_dup pats{i}];
        d_real = [d_real abs(d(i))];
    end
end; clear i
pats = pats_no_dup;
%% try all eigenvectors
dur=30; iter=1e3;
mi_pops = zeros(length(pats), dur);
max_ent = zeros(1,length(pats));
for i = 1 : length(pats)
    probs = 0.5*ones(1,length(pats))/(length(pats)-1);
    probs(i) = 0.5;
    tic
    [Y,pat] = trigger_many_avalanches(A, B, pats, probs, dur, iter);
    toc
    p = pat';
    p(pat==i) = 1;
    p(pat~=i) = 2;
    mi_pops(i,:) = mutual_info_pop(Y,p);
    max_ent(i) = h(p);
end; clear i
%% plot surface
clf
[d_real_sort, idx] = sort(d_real,'descend');
surfl(1:dur,d_real_sort,mi_pops(idx,:))
% surfl(mi_pops)
prettify; axis([0 dur+1 0 1 0 1]); axis vis3d;
xlabel('time'); ylabel('\lambda'); zlabel('MI')



