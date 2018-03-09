function Y = spontaneous_avalanches(A, B, prob, iter)
%spontaneous_avalanches(A, B, prob) gives each node Pr(fire) = prob for
%iter iterations

N = size(A,1);
Y = zeros(N, iter);

Y(:,1) = rand(size(B)) < prob;
for t = 2 : iter
    y_spont = rand(size(B)) < prob;
    Y(:,t) = Y(:,t) + y_spont;
    
end

end

