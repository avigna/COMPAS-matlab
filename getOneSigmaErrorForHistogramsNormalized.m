function [oneSigmaArrayRealNorm, hNormValuesMeanRealNorm] = ...
            getOneSigmaErrorForHistogramsNormalized(    matrixOfInterest,...
                                                        weights,...
                                                        xBins,...
                                                        maxBoostrappingSamples,...
                                                        plotFlag,...
                                                        useLogBins,...
                                                        defaultRNG)
% Function to calculate the one sigma uncertainty on a boostrapped
% distribution of interest
% matrixOfInterest: original distribution of interest
% weights: assigned weights. This array should be the same size as
% `matrixOfInterest`
% xBins: array with bins. Should be the same as the one used for building
% the histograms.
% maxBoostrappingSamples: determines the maximum number of times
% bootstrapping will be effected. The fluctuation of the bootstrapped bin
% scales as 1/sqrt(maxBoostrappingSamples)
% plotFlag: true if you want to print a plot. Useful for careful checks. 
% useLogBins: true if the quantity is analyzed logarithmically (base 10),
% false otherwise
% E.g.:
% getOneSigmaErrorForHistograms(M.CEsToDNSs_eccentricity,M.CEsToDNSs_weights,xBins,100,true,false,true)

if defaultRNG
    rng('default');
end 

% MATLAB Boostrapping function
% y = datasample(data,k) 
% returns k observations sampled uniformly at random, with replacement, from the data in data.
k=length(matrixOfInterest);

for i=1:maxBoostrappingSamples
    [bootstrapped idx] = datasample(matrixOfInterest,k);
    boostrappedDistribution(i,:) = bootstrapped;
    weightsBootStrapped(i,:) = weights(idx);
end


%------------------------------------------------------------------%
maxNumberOfBins = length(xBins);

if useLogBins
    xBinsReal = 10.^xBins;
else
    xBinsReal = xBins;
end
widthBins = diff(xBinsReal);

% Original Data
Y = discretize(matrixOfInterest,xBins);
for index=1:maxNumberOfBins-1
    reWeightedData(index)=sum(weights(find(Y==index)));
end

hOriginal=histogram('BinEdges',xBins,'BinCounts',reWeightedData,'Normalization','Probability');
midValuesOriginal = hOriginal.Values;
normalizedReWeightedData = midValuesOriginal./widthBins;

% Bootstrapped data
for j=1:maxBoostrappingSamples
    bootstrappedY(j,:) = discretize(boostrappedDistribution(j,:),xBins);
    bootstrappedweights(j,:) = weightsBootStrapped(j,:);

    for index=1:maxNumberOfBins-1
        bootstrappedReWeightedData(j,index)=sum(bootstrappedweights(j,find(bootstrappedY(j,:)==index)));
    end

    hNorm=histogram('BinEdges',xBins,'BinCounts',bootstrappedReWeightedData(j,:),'Normalization','Probability');
    hNormValuesRealNorm(j,:) = hNorm.Values./widthBins;
end

%------------------------------------------------------------------%
for k=1:maxNumberOfBins-1
    hNormValuesMeanRealNorm(k) = sum(hNormValuesRealNorm(:,k))./maxBoostrappingSamples;
    eachPointRealNorm(:,k) = (hNormValuesRealNorm(:,k)-hNormValuesMeanRealNorm(k)).^2;
    sigmaSquaredRealNorm(k) = sum(eachPointRealNorm(:,k))./maxBoostrappingSamples;
    sigmaRealNorm(k) = sqrt(sigmaSquaredRealNorm(k)); 
end

oneSigmaArrayRealNorm=sigmaRealNorm;
%------------------------------------------------------------------%
% Plot
if plotFlag
    fs=18;
    lw=2.5;
    string1='$\rm P(something)$';
    string2='$\rm{CDF(something)}$';
    string3='$\rm{Something}$';

    newXBins=xBins(1:end-1)+(diff(xBins)/2);

    clf
    hold on
    histogram('BinEdges',xBins,'BinCounts',normalizedReWeightedData)
    plot(newXBins,normalizedReWeightedData)
    errorbar(newXBins,normalizedReWeightedData,oneSigmaArrayRealNorm,'.')
        
    ylabel(string2,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')
    xlabel(string3,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')

    ax=gca;
    ax.FontSize=fs;
    pbaspect([1 1 1])
    grid on
    grid minor
    box on
end

end