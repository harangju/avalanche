
%%
p = default_network_parameters;
p.num_nodes
p.num_nodes = 10;
p.num_nodes_input = p.num_nodes;
p.num_nodes_output = p.num_nodes;
p.frac_conn = 0.3;
[A,B,C] = network_create(p);
imagesc(A)
prettify; colorbar
[v,d] = eig(A);
d = diag(d)'
max(d)

%%
dur = 10;
[~,idx] = max(d);
% x0 = v(:,idx);
x0 = v(:,1) + v(:,2);
% x0 = v(:,idx) + v(:,3) + v(:,4);

x0 = 10*(x0 + ones(size(x0)));

xt = zeros(size(A,1), dur);
xt(:,1) = x0;
for i = 2 : dur
    xt(:,i) = A * xt(:,i-1);
end; clear i

% imagesc(xt); prettify; colorbar
clf; hold on
for i = 1 : size(A,1)
    plot(xt(i,:),'LineWidth',1.5)
end; clear i; hold off; prettify; colorbar; title('linear')

%%

u = round(x0);
u(u<0) = 0;
Y = avalanche_average_empirical(A,B,u,100,dur);

clf; hold on
C = linspecer(size(A,1));
for i = 1 : size(A,1)
    plot(Y(i,:),'LineWidth',1.5,'color',C(i,:))
end; clear i; hold off; prettify; colorbar; title('random')

%%
idx_v = 6;
x0 = v(:,idx_v) + 1e-2*rand(10,1);
c = v\x0;
dur_exp = log(inv(diag(c))*inv(v)*(0.5*ones(10,1))) ./ d
dur_exp = log(v\ones(10,1)) ./ (c.*d)
[mean(dur_exp) dur_mean(idx_v)]


