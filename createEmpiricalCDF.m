function [sortedQuantityOfInterest, weightedCDF] = createEmpiricalCDF(quantityOfInterest, weights)
totalSumWeights = sum(weights);
[sortedQuantity,Index] = sort(quantityOfInterest);
cumulativeSumVector = cumsum(weights(Index));
normalizedCumulativeSumVector = cumulativeSumVector./totalSumWeights;

sortedQuantityOfInterest = sortedQuantity;
weightedCDF = normalizedCumulativeSumVector;
end