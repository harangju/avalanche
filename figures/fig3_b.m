%% try loading pre-generated data
if exist('source_data_dir','var')
    load([source_data_dir '/fig3_b.mat'])
else
    N = 10;
    A0 = triu(ones(N)) - eye(N);
    A0 = A0 .* 0.2;
    % rewire probabilities
    ps = 0 : 0.1 : 1;
    trials = 10;
    durs = cell(length(ps),trials);
    As = cell(length(ps),trials);
    graphs = cell(length(ps),trials);
    Ys = cell(length(ps),trials);
    i_y0s = cell(length(ps),trials);
    % simulation
    Tmax = 1e4; K = 1e4;
    [y0s,p_y0s] = pings_single(N);
    if exist('fig3_b','file') ~= 7
        mkdir('fig3_b')
    else
        error('Folder named fig3_b already exists.')
    end
    for i = 1 : length(ps)
        fprintf(['Rewire with p=' num2str(ps(i)) '\n\tTrial: '])
        for j = 1 : trials
            fprintf([num2str(j) ' '])
            As{i,j} = network_rewire(A0,ps(i));
            [Ys{i,j},i_y0s{i,j}] = simulate(@smp,As{i,j},y0s,Tmax,p_y0s,K);
        end
        fprintf('\n')
    end
    clear i j
    durs = cellfun(@csc_durations,Ys,'uniformoutput',0);
    durm = cellfun(@mean,durs);
    cycles = cellfun(@find_struct_cycles,As,'uniformoutput',0);
    cycle_count = cellfun(@length,cycles);
end
%% fig3b
figure
x = cycle_count(:)/sum(sum(A0>0));
y = durm(:);
[r,p] = corr(x,y);
scatter(x,y,50,'k.')
prettify
f = polyfit(x,y,1);
x = min(x) : 1e-2 : max(x);
hold on
plot(x, x*f(1)+f(2),'r')
hold off
clear x y z f
