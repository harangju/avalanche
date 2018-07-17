
%%
p = default_network_parameters;
p.graph_type = 'RG';
p.num_nodes = 30;
p.num_nodes_input = p.num_nodes;
p.frac_conn = 0.05;
[A,B] = network_create(p);
A = scale_weights_to_criticality(A);
%% normal weighting
A = A .* 0.5;
A(A<0) = 0;
A = scale_weights_to_criticality(A);
%% bimodal weighting
for i = 1 : p.num_nodes
    a = A(i,:);
    am = mean(a(a>0));
    A(i,:) = (a>am) .* 0.95 + (a<am & a>0) .* 0.05;
end; clear i a am
A = scale_weights_to_criticality(A);
%%
imagesc(A); prettify; colorbar
%%
pats = cell(1,p.num_nodes);
for i = 1 : p.num_nodes
    pats{i} = zeros(p.num_nodes,1);
    pats{i}(i) = 1;
end
%%
dur = 1e3; iter = 3e3;
probs = ones(1,length(pats)) / length(pats);
tic
[Y,pat] = trigger_many_avalanches(A,B,pats,probs,dur,iter);
toc; beep
%%
activity = squeeze(sum(Y,1))';
durations = zeros(1,iter);
for i = 1 : iter
    if sum(activity(i,:)) > 0
        durations(i) = find(activity(i,:)>0,1,'last');
    else
        durations(i) = 0;
    end
end; clear i
%%
[c_d,e_d,bin_idx] = histcounts(durations,100);
x = log10(e_d(2:end));
y = log10(c_d/sum(c_d));
x(isinf(y)) = [];
y(isinf(y)) = [];
f = polyfit(x(1:20),y(1:20),1);
% f = polyfit(x,y,1);
disp(f)
%%
scatter(x,y,'.')
prettify
hold on
plot(x,polyval(f,x))
hold off