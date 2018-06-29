B = [0 0.9 0; 0 0 0.9; 0.9 0 0]'
[v,d] = eig(B)
x = [2 0 0]'; c = v\x; t = 6;
[[x c d*c d^t*c v*d^t*c]; [norm(x) norm(c) norm(d*c) norm(d^t*c) norm(v*d^t*c)]]
