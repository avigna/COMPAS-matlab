function HRD_quantityOfInterest(     quantityOfInterest,...
                                    luminosity,...
                                    effectiveTemperature,...
                                    weights,...
                                    logQoF,...
                                    setLimitsManually,...
                                    printToFile,...
                                    nameString)
% This function creates a Hertzsprung-Russell Diagram (HRD) of a quantity of interest, which can be
% printed and/or saved
% quantityOfInterest: quantity you want to plot, e.g. radius, total mass, etc.
% luminosity: y-axis location in HRD of `quantityOfInterest` in Solar
% Luminosities
% effectiveTemperature: x-axis location in HRD of `quantityOfInterest` in
% Kelvin
% weights: assigned weights. This array should be the same size as
% `quantityOfInterest`
% logQoF: true if the quantity will be plotted logarithmically (base 10), false otherwise 
% setLimitsManually: if true, sets the limits as defined within this
% function (see close to end)
% printToFile: true if you want to save the plot into a file
% nameString: string with the name that will be saved into a file
%
% Example:
% HRD_quantityOfInterest(     eccentricity,...
%                             luminosity,...
%                             effectiveTemperature,...
%                             weights,...
%                             false,...
%                             false,...
%                             true,...
%                             'e')                                 

if logQoF
    quantityOfInterest = log10(quantityOfInterest);
end

% Plot
colormap(parula(1000))
sc0=100;
fs=16;
alphaNum=0.6;
stringX='$\log_{10}\ T_{\rm{eff,donor}}/\rm{K}$';
stringY='$\log_{10}\ L_{\rm{donor}}/\rm{L_{\odot}}$';
stringC = strcat('$',nameString,'$');

clf
hold on
s1=scatter(log10(effectiveTemperature),log10(luminosity),sc0.*weights,quantityOfInterest,'o','Filled');
alpha(s1,alphaNum)

xlabel(stringX,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')
ylabel(stringY,'FontSize',fs,'Interpreter','Latex','FontName','Helvetica')

ax=gca;
ax.FontSize=fs;
ax.XDir='reverse';
cbar=colorbar;
cbar.Label.Interpreter='latex';
cbar.Label.String = stringC;
cbar.FontSize=fs;
pbaspect([1 1 1])
box on

if setLimitsManually
    ax.XLim = [3 5];
    ax.YLim = [4 6];
    cbar.Limits = [min(quantityOfInterest) max(quantityOfInterest)];
end

if printToFile
    nameToPrint = strcat('./plots/HR_',nameString,'.png');
    print(gcf,nameToPrint,'-dpng','-r300');   
end

end