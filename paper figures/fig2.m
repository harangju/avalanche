
%% 3-node network
p = default_network_parameters;
p.num_nodes = 3;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = .95;
p.graph_type = 'WRG';
p.exp_branching = 1;
[A, B, C] = network_create(p);
% A = scale_weights_to_criticality(A);
%% view
imagesc(A)
colorbar
prettify
%% 
% x0 = [3 5 1]';
x = [A'^0*x0 A'^1*x0 A'^2*x0 A'^3*x0 A'^4*x0 A'^5*x0 A'^6*x0 A'^7*x0...
    A'^8*x0 A'^9*x0 A'^10*x0 A'^11*x0];
plot3(x(1,:),x(2,:),x(3,:),'*-')
axis([0 inf 0 inf 0 inf])
prettify; axis vis3d; xlabel('x'); ylabel('y'); zlabel('z');

