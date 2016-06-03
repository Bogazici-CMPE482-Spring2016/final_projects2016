function [w, pred] = project_part2(D_tau, salesdata1, varargin)
[numOfItems, numOfMonths] = size(salesdata1);
A = zeros(numOfMonths-D_tau,D_tau*numOfItems,numOfItems);

pred = zeros(numOfItems,1);
w = zeros(numOfItems,numOfItems,D_tau);
for i=1:numOfItems
    % Construct the basis
    for t=1:D_tau
        A(:,(t-1)*numOfItems+1:t*numOfItems,i) = salesdata1(:,t:end-D_tau+t-1)';
    end
    % Least Squares
    b = salesdata1(i,D_tau+1:end)';
    if sum(sum(isnan(A(:,:,i)))) + sum(isnan(b)) > 0
        params = lsMissing(A(:,:,i),b);
    else
        params = A(:,:,i)\b;
    end
    for t=1:D_tau
        w(i,:,t) = params((t-1)*numOfItems+1:t*numOfItems);
    end
    % Estimate
    a = zeros(1,D_tau*numOfItems);
    for t=1:D_tau
        a((t-1)*numOfItems+1:t*numOfItems) = salesdata1(:,end-D_tau+t)';
    end
    pred(i,1) = a*params;
end

if nargin > 2
    testdata1 = varargin{1};
    fprintf('Errors (Euclidian norms)\n');
    totalError = 0;
    for i=1:numOfItems
        error = norm(pred(i,1)-testdata1(i,1));
        fprintf('Item %d: %f\n',i,error);
        totalError = totalError + error;
    end
    fprintf('Total : %f\n\n',totalError);
end

end