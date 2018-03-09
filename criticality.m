

%% driven mode
% given A, B
iter = 1e3; dur = 7; bins = 20;
Y = ping_nodes(A, B, iter, dur);
[s, e] = avalanche_size_distr(Y, bins);
f = avalanche_size_distr_exp_fit(s,e);
disp(['Slope: ' num2str(f.a)])

%% spontaneous mode


% 1. Criticality arises when a system is close to dynamic instability and is reflected by scale-free temporal and spatial fluctuations
% 2. Critical temporal fluctuations (crackling noise) occur in simple systems close to a bifurcation
% 3. Critical spatiotemporal fluctuations (avalanches) occur in complex systems close to a phase transition
% 4. Crackling noise and avalanches have now been observed in a wide variety of neuronal recordings, at different scales, in
% different species, and in health and disease
% 5. Computational models suggest a host of adaptive benefits of criticality, including maximum dynamic range, optimal
% information capacity, storage and transmission and selective enhancement of weak inputs
% 6. 6. Resting-state EEG and fMRI data show evidence of critical dynamics
% 7. The onset of a specific cognitive function may reflect the stabilization of a particular subcritical state under the influence of
% sustained attention
% 8. Mounting evidence and models suggest that several neurological disorders such as epilepsies and neonatal encephalopathy
% reflect bifurcations and phase transitions to pathological states
% 9. Novel insights into neuropsychiatric disorders such as schizophrenia and melancholia might also be obtained by leveraging
% the tools of criticality, although this currently remains somewhat speculative
% 10. While the application of criticality to neuroscience is an exciting field, progress needs to proceed with due caution, using
% appropriate methods, considering alternative complex processes and using computational models in partnership with data analysis


