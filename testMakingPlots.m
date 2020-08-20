function testMakingPlots
% Function to test the plot functionality 

% Uncomment to display whole HDF5 file information
% h5disp('COMPASOutput.h5')
M=h5info('COMPASOutput.h5');
M.Groups.Name


% Display information about a single dataset from a single group.
h5disp('COMPASOutput.h5','/commonEnvelopes/TeffDonor')
h5readatt('COMPASOutput.h5','/commonEnvelopes/TeffDonor','Unit')
h5readatt('COMPASOutput.h5','/commonEnvelopes/TeffDonor','Description')

% Display information from some example quantities.
h5disp('COMPASOutput.h5','/binaryProperties/weight')
h5readatt('COMPASOutput.h5','/binaryProperties/weight','Unit')
h5readatt('COMPASOutput.h5','/binaryProperties/weight','Description')

weight =h5read('COMPASOutput.h5','/binaryProperties/weight');
luminosityDonor=h5read('COMPASOutput.h5','/commonEnvelopes/luminosityDonor');
TeffDonor =h5read('COMPASOutput.h5','/commonEnvelopes/TeffDonor');
eccentricity =h5read('COMPASOutput.h5','/commonEnvelopes/eccentricityPreCEE');

% Plot eccentricity. C.f. figure 3 of paper.
% Plot HRD. 
% For more info, read details from HRD_quantityOfInterest function.
quantityOfInterest = eccentricity;
luminosity = luminosityDonor;
effectiveTemperature = TeffDonor;
weights = weight;
logQoF = false;
setLimitsManually = false;
printToFile = false;
nameString = 'eccentricity';

figure()
HRD_quantityOfInterest(     quantityOfInterest,...
                            luminosity,...
                            effectiveTemperature,...
                            weights,...
                            logQoF,...
                            setLimitsManually,...
                            printToFile,...
                            nameString)                    
                    
% Plot histogram. 
% For more info, read details from histogram_quantityOfInterest function.
minQoI = 0;
maxQoI = 1;
numberOfBins = 21;
labelXaxis = 'eccentricity';

figure()
histogram_quantityOfInterest(   eccentricity,...
                                    weight,...
                                    minQoI,...
                                    maxQoI,...
                                    numberOfBins,...
                                    logQoF,...
                                    printToFile,...
                                    nameString,...
                                    labelXaxis)
                
% Uncomment if you want to plot subpopulations. C.f. figure 5 of paper.
subpopulation =h5read('COMPASOutput.h5','/postProcessingQuantities/subpopulationType');
% Plot HRD. 
% For more info, read details from HRD_quantityOfInterest function.
quantityOfInterest = subpopulation;
luminosity = luminosityDonor;
effectiveTemperature = TeffDonor;
weights = weight;
logQoF = false;
setLimitsManually = false;
printToFile = false;
nameString = 'subpopulation';

figure()
HRD_quantityOfInterest(     quantityOfInterest,...
                            luminosity,...
                            effectiveTemperature,...
                            weights,...
                            logQoF,...
                            setLimitsManually,...
                            printToFile,...
                            nameString)                    
                    
% Plot histogram. 
% For more info, read details from histogram_quantityOfInterest function.
minQoI = 0.5;
maxQoI = 3.5;
numberOfBins = 4;
labelXaxis = 'subpopulation';

figure()
histogram_quantityOfInterest(   subpopulation,...
                                    weight,...
                                    minQoI,...
                                    maxQoI,...
                                    numberOfBins,...
                                    logQoF,...
                                    printToFile,...
                                    nameString,...
                                    labelXaxis)


end