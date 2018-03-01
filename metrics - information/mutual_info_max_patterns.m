function [summary, input_entropy, max_mi, max_nodes, max_time, ...
    mean_sizes] = mutual_info_max_patterns(A, B, C, patterns, dur, iter)
%mutual_info_max_patterns 
%   A: connectivity matrix
%   B: input connectivity vector
%   C: output connectivity vector
%   patterns: a cell array of patterns
%       a pattern is a cell array of nodes to activate across time
%   dur: max duration of avalanche
%   iter: iterations of presentations for each pattern in patterns
%   plot_aval: boolean, if true, plots mean avalanches
% returns
%   summary: matrix with column 1-max_mi, column 2-nodes for max_mi,
%       column 3-times for max_mi
%   max_mi: max mutual information for node&time
%   max_nodes: the nodes for max_mi
%   max_time: the time in the avalanche for max_mi
%   mean_sizes: mean avalanche size for each pattern

% iter = 1e2; dur = 4;
probs = [0.5 0.5];
input_entropy = zeros(1,length(patterns));
max_mi = cell(1,length(patterns));
max_nodes = cell(size(max_mi));
max_time = cell(size(max_mi));
mean_sizes = zeros(size(max_mi));
for i = 1 : length(patterns)
    disp(['pattern: ' num2str(i) '/' num2str(length(patterns))])
    [Y, pat, s] = trigger_many_avalanches(A, B, patterns{i}, probs, dur,...
        iter);
    mean_sizes(i) = mean(s);
    info = mutual_info(Y, pat);
    input_entropy(i) = h(pat');
    [max_mi{i}, max_nodes{i}, max_time{i}] = mutual_info_max(info, C,...
        max(cellfun(@length,patterns{i})));
end
summary = zeros(length(patterns), 4);
for i = 1:length(patterns)
    [~,idx] = max(max_mi{i});
    if isempty(idx); continue; end
    summary(i,:) = [input_entropy(i) max_mi{i}(idx) max_nodes{i}(idx)...
        max_time{i}(idx)];
end

end
