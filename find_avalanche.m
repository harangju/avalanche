% find_avalanche.m

%% load
load('network.mat')

%% parameters


%% iterate
avalanche
for n = 1 : N
    
    avalanche = trigger_avalanche(n);
end

clear n pre

%% plot
clf
for a = 1 : length(avalanche)
    avalanche{a}
end

clear a