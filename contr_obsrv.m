%% load data
load(['/Users/harangju/Developer/cascade paper data' ...
    '/data/Dataset01.mat']);
spikes = spike_times_to_bins(data.spikes,5);
cascades = detect_cascades(spikes);
n = net.generate('autoregressive',...
    'v',spikes','pmin',1,'pmax',1);
n.v = [];
%% plot network
imagesc(n.A)
% colorbar_colors = [ones()];
colorbar
%% controllability & observability
fac = finite_impulse_responses(n.A,10);
fao = finite_impulse_responses(n.A',10);
clf
hold on
plot(fac,'.')
plot(fao,'.')
%% mutual information
dt = 4;
mio = zeros(length(n.A),dt);
pato = cell(length(n.A),dt);
mii = zeros(length(n.A),dt);
pati = cell(length(n.A),dt);
for i = 1 : length(n.A)
    fprintf(['Neuron ' num2str(i) ', dt ='])
    for j = 1 : size(mio,2)
        fprintf([' ' num2str(j)])
        [mio(i,j), pato{i,j}] = mutual_info_pop(...
            permute(spikes(:,1+j:end), [1 3 2]), spikes(i,1:end-j)');
        [mii(i,j), pati{i,j}] = mutual_info_pop(...
            permute(spikes(:,1:end-j), [1 3 2]), spikes(i,1+j:end)');
    end
    fprintf('\n')
end
clear i j
%%
clf
subplot(1,2,1)
hold on
for i = 1 : dt
    plot(fac,mio(:,i),'.','MarkerSize',10)
end
prettify
subplot(1,2,2)
hold on
for i = 1 : dt
    plot(fao,mii(:,i),'.','MarkerSize',10)
end
prettify
clear i
%% correlations - pearson's rho
[r_out,p_out] = corr(fac,mio,'Type','Pearson');
[r_in,p_in] = corr(fao,mii,'Type','Pearson');
%% imagesc
clf
imagesc(n.A)
% colorbar
npos = int32(1000*max(max(n.A)));
nneg = int32(1000*-min(min(n.A)));
colors = [ones(nneg,1) linspace(0,1,nneg)' linspace(0,1,nneg)';...
    linspace(1,0,npos)' linspace(1,0,npos)' ones(npos,1)];
colormap(colors)
colorbar
prettify