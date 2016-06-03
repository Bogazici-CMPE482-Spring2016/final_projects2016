function predictions = project1(salesdata1,varargin)

seasonLength=4;
predictionLength=6;
[numOfItems, numOfMonths] = size(salesdata1);
A = zeros(numOfMonths-1,1+seasonLength,numOfItems);

predictions = zeros(numOfItems,predictionLength);
for i=1:numOfItems
    
    % Construct the basis
    A(:,1,i) = salesdata1(i,2:end);
    for j=1:seasonLength
        A(j:seasonLength:end,j+1,i)=1;
    end
    
    b = salesdata1(i,1:end-1)';
    % Least Squares
    if sum(sum(isnan(A(:,:,i)))) + sum(isnan(b)) > 0
        params = lsMissing(A(:,:,i),b);
    else
        params = A(:,:,i)\b;
    end
    a = zeros(1,seasonLength+1);
    for t=1:predictionLength
        if t==1, a(1)=A(end,1,i); else a(1)=predictions(i,t-1); end
        for s=1:seasonLength
            a(s+1) = mod(numOfMonths+t,seasonLength) == s;
        end
        predictions(i,t) = a*params;
    end
end

if nargin > 1
    testdata1 = varargin{1};
    fprintf('Errors (Euclidian norms)\n');
    totalError = 0;
    for i=1:numOfItems
        error = norm(predictions(i,:)-testdata1(i,:));
        fprintf('Item %d: %f\n',i,error);
        totalError = totalError + error;
    end
    fprintf('Total : %f\n',totalError);
end

end