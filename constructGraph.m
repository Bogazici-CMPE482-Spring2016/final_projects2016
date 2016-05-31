function [G, W] = constructGraph(points,K,sigma)
    N=size(points,1);
    G = zeros(N);
    W = zeros(N);
    for i=1:N
        dists = zeros(1,N);
        for j=1:N
            dists(j) = norm(points(i,:)-points(j,:));
        end
        [B,I] = sort(dists);
        for k=2:K+1
            G(i,I(k))=1;
            G(I(k),i)=1;
            W(i,I(k))=exp(-0.5*(B(k)/sigma)^2);
            W(I(k),i)=W(i,I(k));
        end
    end
end