function histogram_quantityOfInterest(   quantityOfInterest,...
                                    weights,...
                                    minQoI,...
                                    maxQoI,...
                                    numberOfBins,...
                                    logQoF,...
                                    printToFile,...
                                    nameString,...
                                    labelXaxis)
% This function creates a histogram of a quantity of interest, which can be
% printed and/or saved
% 
% quantityOfInterest: quantity you want to plot, e.g. luminosity, radius,
% total mass, etc.
% weights: assigned weights. This array should be the same size as
% `quantityOfInterest`
% minQoI: minimum value of the `quantityOfInterest` in linear units 
% maxQoI: maximum value of the `quantityOfInterest` in linear units
% numberOfBins: number of bins in the histogram
% logQoF: true if the quantity will be plotted logarithmically (base 10), false otherwise 
% printToFile: true if you want to save the plot into a file
% nameString: string with the name that will be saved into a file
% labelXaxis: x-axis label in latex format.
%
% Example: hist_quantityOfInterest(M.CEsToDNSs_luminosity,...
% M.CEsToDNSs_weights,10^4,10^6,21,true,false,'Luminosity','Luminosity/L_{\odot}')
% Example: hist_quantityOfInterest(M.CEsToDNSs_mass,...
% M.CEsToDNSs_weights,0,40,21,false,true,'massDonor','m_{donor}')

%------------------------------------------------------------------%
% Check if `quantityOfInterest` is going to be printed in linear or log
% scale
if logQoF
    minQoI = log10(minQoI);
    maxQoI = log10(maxQoI);
    xBins=linspace(minQoI,maxQoI,numberOfBins);
    xBinsReal = 10.^xBins;
    string3 = strcat('$\log_{10}\ \rm{',labelXaxis,'}$');
    quantityOfInterest = log10(quantityOfInterest);
else
    xBins=linspace(minQoI,maxQoI,numberOfBins);
    xBinsReal = xBins;
    string3 = strcat('$\rm{',labelXaxis,'}$');
end

toDisplay1 = sprintf('The minimum and maximum value of the `quantity of interest` variable are: %f and %f.',min(quantityOfInterest),max(quantityOfInterest));
toDisplay2 = sprintf('The minimum and maximum value of the chosen bins are: %f and %f.',minQoI,maxQoI);
disp(toDisplay1)
disp(toDisplay2)

if (min(quantityOfInterest)<minQoI) | (max(quantityOfInterest>maxQoI))
    warning('The quantity of interest spans a larger parameter space than that set by the chosen bins.')
end
%------------------------------------------------------------------%
% Create histogram
widthBins = diff(xBinsReal);
Y = discretize(quantityOfInterest,xBins);

for index=1:numberOfBins-1
    reWeightedData(index)=sum(weights(find(Y==index)));
end

h1=histogram('BinEdges',xBins,'BinCounts',reWeightedData,'Normalization','Probability');
normalizedReWeightedData=h1.Values./widthBins;
%------------------------------------------------------------------%
% Create CDF
[sortedQuantityOfInterest, weightedCDF] = createEmpiricalCDF(quantityOfInterest, weights);
%------------------------------------------------------------------%
% Get error bars
[oneSigma, hNormValuesMean] = getOneSigmaErrorForHistogramsNormalized(quantityOfInterest,weights,xBins,100,false,logQoF,true);
newXBins = xBins(1:end-1)+(diff(xBins)/2);
%------------------------------------------------------------------%
% Plot
fs=18;
lw=2.5;
lwError=1.5;
string1 = strcat('$\rm{P(',labelXaxis,')}$');
string2='$\rm{CDF}$';

% % You can manually change strings here
% string1 = '$string1$';
% string2 = '$string2$';
% string3 = '$string3$';

clf
yyaxis left
hold on
histogram('BinEdges',xBins,'BinCounts',normalizedReWeightedData,'EdgeColor','None');
errorbar(newXBins,normalizedReWeightedData,oneSigma,'.k','Linewidth',lwError)
ylabel(string1,'Interpreter','Latex','Fontsize',fs)


yyaxis right
plot(sortedQuantityOfInterest,weightedCDF,'LineWidth',lw)
ylabel(string2,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')
xlabel(string3,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')
ylim([0 1])
ax=gca;
ax.FontSize=fs;

pbaspect([1 1 1])
grid on 
grid minor
box on

% Print to file
if printToFile
    nameToPrint = strcat('./plots/hist_',nameString,'.png');
    print(gcf,nameToPrint,'-dpng','-r300');    
end
end