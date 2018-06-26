

%% 0.a autaptic 
N = 100;
bound = [0 0.99];
% k = rand(1,N);
% alpha = 1.5;
% A = diag((1-k).^(1/(-alpha+1)));
x = rand(1,N) * (bound(2) - bound(1)) + bound(1);
% A = diag([rand(1,N/4)/2 rand(1,N*3/4)/2+0.5]);
B = ones(N,1);

%% 0.a random geometric
N = 100;
p = default_network_parameters;
p.num_nodes = N;
p.num_nodes_input = N;
p.num_nodes_output = N;
p.frac_conn = 0.1;
p.graph_type = 'RG';
[A,B,C] = network_create(p);
A = scale_weights_to_criticality(A);
plot(graph_from_matrix(A))

%% 0.a weigthed random / Erdos-Renyi
N = 100;
p = default_network_parameters;
p.num_nodes = N;
p.num_nodes_input = N;
p.num_nodes_output = N;
p.frac_conn = 0.03;
p.graph_type = 'WRG';
[A,B,C] = network_create(p);
A = scale_weights_to_criticality(A);

%% 0.b stimulus
scale = 10;
[v,d] = eig(A);
d = diag(d);
pats = cell(1,N);
duplicates = 0;
for i = 1 : N
    pats{i} = v(:,i);
    if ~isreal(d(i))
        if i < N && abs(d(i)) == abs(d(i+1))
            pats{i} = v(:,i) + v(:,i+1);
        elseif abs(d(i)) == abs(d(i-1))
            pats{i} = v(:,i) + v(:,i-1);
            duplicates = duplicates + 1;
        end
    end
    if find(pats{i}<0); pats{i} = -1 * pats{i}; end
    pats{i}(pats{i}<0) = 0;
    pats{i} = abs(pats{i});
    pats{i} = round(scale * pats{i});
end; clear i
%% 0.c remove duplicates
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
clear pats_no_dup

%% 1. network
figure(1)
imagesc(A)
prettify; colorbar
set(gca,'FontSize',14);

%% 2.a power law - simulation
dur = 1e3; iter = 1e4;
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep

%% 2.a power law - duration
activity = squeeze(sum(Y,1))';
%%
durations = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        durations(i) = find(activity(i,:)>0,1,'last');
    else
        durations(i) = 0;
    end
end; clear i

%% 2.b power law - size
sizes = zeros(1,iter);
for i = 1 : iter
    sizes(i) = sum(sum(Y(:,:,i),2)>0);
end; clear i

%% 2.c.1 power law distribution - duration
% calculate average eigenvalue for bin
[c_d,e_d,bin_idx] = histcounts(durations,100);
d_pat = d_real(pat)';
d_bin = zeros(1,length(c_d));
for i = 1 : length(d_bin)
    d_bin(i) = mean(abs(d_pat(bin_idx==i)));
    if isnan(d_bin(i)); d_bin(i) = 0; end
end; clear i
%% 2.c.2 
figure(2)
clf; hold on
% plot(log10(e_d(2:end)), log10(c_d/sum(c_d)), '-*')
scatter(log10(e_d(2:end)), log10(c_d/sum(c_d)), 32, d_bin, 'filled')
% plot(e_d(2:end), c_d/sum(c_d), '-*')
colorbar
hold off; prettify
%% 2.c.3 - linear fit
x = log10(e_d(2:end));
y = log10(c_d/sum(c_d));
x(isinf(y)) = [];
y(isinf(y)) = [];
f = polyfit(x,y,1)
pts = min(x) : 1e-2 : max(x);
hold on
plot(pts, f(2) + pts*f(1), 'k')
hold off

%% 2.d power law distribution - size
figure(3)
clf; hold on
[c_s,e_s] = histcounts(sizes,100);
scatter(log10(e_s(1:end-1)), log10(c_s/sum(c_s)), 'filled')
hold off; prettify

%% 3.a mutual information - simulation
dur = 30; iter = 1e3;
mi_pops = zeros(length(pats), dur);
for i = 1 : length(pats)
    probs = 0.5*ones(1,length(pats)) / (length(pats)-1);
    probs(i) = 0.5;
    disp([num2str(i) '/' num2str(length(pats))])
    tic
    [Y_mi,pat_mi] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
    toc
    pa = pat_mi'; pa(pat_mi==1) = 1; pa(pat_mi~=i) = 2;
    mi_pops(i,:) = mutual_info_pop(Y_mi,pa);
end; clear i pa

%% 3.b mutual information - plot
figure(4)
clf; colormap parula
[d_real_sort,idx] = sort(d_real,'descend');
range = [1:2 4:length(d_real_sort)];
surf(0:dur-1, d_real_sort(range),...
    mi_pops(idx(range),:), 'LineWidth', 0.1);
% surf(0:dur-1, d_real_sort,...
%     mi_pops(idx,:), 'LineWidth', 0.1);
prettify; axis([0 dur 0 1 0 1]); axis vis3d
set(gca,'FontSize',14);
 



