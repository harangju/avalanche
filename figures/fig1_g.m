%% source
% uncomment to use same data from paper, Ju et al. 2019
% basedir = '~/Downloads/Source Data';
%% simulate
N = 10;
P = 0.2;
if exist('basedir','var')
    load([basedir '/fig1_g'])
else
    num_neur = 50 : 50 : 300;
    Tmax = 15;
    K = 1e4;
    Ys = cell(1,length(num_neur));
    i_y0s = cell(1,length(num_neur));
    Xs = cell(1,length(num_neur));
    for i = 1 : length(num_neur)
        num = num_neur(i);
        disp(num)
        n = net.generate('erdosrenyi','n',N,'p',P,'dir',true);
        n.A = n.A./sum(n.A,1);
        n.A(isnan(n.A)) = 0;
        [y0s, p_y0s] = pings_single(size(n.A,1));
        [Ys{i},i_y0s{i}] = simulate(@smp,n.A,y0s,Tmax,p_y0s,K);
        Xs{i} = simulate(@linear,n.A,y0s,Tmax);
    end; clear i num n pats probs
end
%% calculate
if ~exist('basedir','var')
    df = cell(1,length(num_neur));
    for i = 1 : length(num_neur)
        df{i} = 0;
        for num = 1 : N
            Y_n = csc_cell_to_mat(Ys{i}(i_y0s{i}==num));
            Y_n_avg = mean(Y_n,3);
            df{i} = [df{i}; Y_n_avg(Y_n_avg>0) - Xs{i}{num}(Y_n_avg>0)];
        end
    end
    clear i n Y_n Y_n_avg
end
%% g
df_m = cellfun(@mean,df);
df_sd = cellfun(@std,df);
figure
errorbar(num_neur, df_m, df_sd, 'ks')
