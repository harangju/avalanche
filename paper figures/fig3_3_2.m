%% parameters
A0 = [0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 0 0];
N = 4;
B = ones(N,1);
redistr = 0.1;
dur = 1e4;
iter = 1e4;
dws = 0.02 : 0.02 : 0.98;
seed = 4;
%% create network
As = cell(1,length(dws));
for i = 1 : length(dws)
    rng(seed)
    As{i} = A0;
    for n = 1 : N
        og = find(A0(n,:));
        As{i}(n,og) = A0(n,og) - dws(i);
        new = randperm(N,1);
        while new == og
            new = randperm(N,1);
        end
        As{i}(n,new) = dws(i);
    end; clear n
end; clear i
%% simulate
[pats, probs] = pings_single(N);
Ys = cell(1,length(dws));
orders = cell(1,length(dws));
disp(repmat('#',[1 length(dws)]))
for i = 1 : length(dws)
    fprintf('.')
    [Ys{i}, orders{i}] = avl_smp_many(pats, probs, As{i}, dur, iter);
end; clear i; fprintf('\n')
