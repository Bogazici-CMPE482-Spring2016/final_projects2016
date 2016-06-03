function A = constructBasis(dataSet,seasonLength)

[numOfItems, numOfMonths] = size(dataSet);
A = zeros(numOfMonths-1,1+seasonLength,numOfItems);

for i=1:numOfItems
    itemSales = dataSet(i,:);
    A(:,1,i) = itemSales(2:end);
    for j=1:seasonLength
        A(j:seasonLength:end,j+1,i)=1;
    end
end

end