function x = lsMissing(A,b)
missA = isnan(A);
missb = isnan(b);

A(missA) = 0;
b(missb) = 0;

Aprev = A;
xprev = ones(size(A,2),1);

epsilon = 1e-10;
for t=1:1000
    x = A\b;
    
    [U, S, V] = svd(x,0);
    Sinv = 1./S;
    Sinv(isinf(Sinv)) = 0;
    Anew = b*V'*Sinv*U';
    A(missA) = Anew(missA);
    bnew = A*x;
    b(missb) = bnew(missb);
    
    if norm(A-Aprev,'fro') < epsilon || norm(xprev-x,'fro') < epsilon
        break;
    end
    Aprev = A;
    xprev = x;
    
end
end