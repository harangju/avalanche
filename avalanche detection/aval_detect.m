
%%
load('beggs data/DataSet2.mat')
%% detect avalanches
bin_size = 4;
avalanches = detect_avalanches(data.spikes, bin_size);
%% compute node participation
% how much a node participates in long avalanches
% per node, per avalanche, activation throughout avalanche
% per node, avalanche activation throughout avalanche
N = length(data.spikes);
part = cell(1,N);
for n = 1 : N
    for a = 1 : length(avalanches)
        aval = avalanches{a};
        part{n} = [part{n} find(aval(n,:))];
    end; clear a aval
end; clear n
%% summarize information
occur_mean = cellfun(@mean,part);
bar(occur_mean)
prettify; xlabel('neurons'); ylabel('mean occurrence in avalanche')
%%
A_raw = estimate_network_from_spikes(data, 0.1);
beep
%%
deg = outdegree(A_raw) + indegree(A_raw);
A = A_raw(deg>0,deg>0);
B = ones(1,size(A,1));
A = scale_weights_to_criticality(A);
%% check connectivity
disp(mean(A(:)>0))
%% eigendecomposition
[v,d] = eig(A);
d = diag(d);
%% get real eigenvectors
v_real = zeros(params.num_nodes,params.num_nodes);
d_real = zeros(1,params.num_nodes);
for i = 1 : params.num_nodes
    v_real(:,i) = v(:,i);
    if ~isreal(d(i))
        if i < params.num_nodes &&...
                abs(d(i)) == abs(d(i+1))
            v_real(:,i) = v(:,i) + v(:,i+1);
            d_real(i) = d(i) + d(i+1);
        elseif abs(d(i)) == abs(d(i-1))
            v_real(:,i) = v(:,i) + v(:,i-1);
            d_real(i) = d(i) + d(i-1);
        end
    end
    if find(v_real(:,i)<0); v_real(:,i) = -1 * v_real(:,i); end
end; clear i
%% scale by eigenvalue
score = max(abs(d .* v),[],2);
%%
subplot(2,1,1)
bar(occur_mean(deg>0))
subplot(2,1,2)
bar(score)
ylabel('score')
xlabel('neurons')
set(gca,'FontSize',16);
subplot(2,1,1)
ylabel('mean occurrence')
set(gca,'FontSize',16);
%%
scatter(score,occur_mean(deg>0), 'filled')
prettify
xlabel('score'); ylabel('occurrence')


%% strong eigenvectors



