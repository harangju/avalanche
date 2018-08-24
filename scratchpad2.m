
%%
prm = default_network_parameters;
prm.N = 100;
prm.frac_conn = 0.1;
[A, B] = network_create(prm);
A = scale_weights_to_criticality(A);

%%

