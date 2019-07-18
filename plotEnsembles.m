% plotEnsembles.m
%
% julia dohner
% july 24, 2018

function plotEnsembles(LUensembleArray,nLU)

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/MATLAB_toolkits'));

h1 = figure('Name','Modeled CO2a Ensembles');
h2 = figure('Name','Obs-Calc CO2a Difference');
h3 = figure('Name','Obs-Calc AGR Difference');
legendInfo = {};
%colorVec = hsv(nLU);
colorVec = {'-g';'-b';'-r'};
hold all

ts = 12;
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5;
vary = 'A';
[dtdelpCO2a_obs,~,~,~,~,~] = ...
    getObservedCO2_2wNoise(ts,start_year,start_yearOcean,end_year,vary);


for i = 1:nLU
    legendInfo{i} = LUensembleArray{i+1,1};
    outputArray = LUensembleArray{i+1,2};
    numCases = LUensembleArray{i+1,3};
    year = LUensembleArray{i+1,4};
    
    year1 = year';

    % compile all CO2a and AGR error values
    blankVec = zeros(length(year),numCases);
    allVals_CO2a = blankVec;
    allVals_CO2error = blankVec;
    allVals_AGRdiff = blankVec;

    for j = 1:numCases
        allVals_CO2a(:,j) = outputArray{j+1,6};

        obsCalcDiff = outputArray{j+1,7};
        allVals_CO2error(:,j) = obsCalcDiff(:,2);
        
        dtdelpCO2a_model = outputArray{j+1,18};
        allVals_AGRdiff(:,j) = dtdelpCO2a_model(:,2)-dtdelpCO2a_obs(:,2);
    end
    
    set(0,'CurrentFigure',h1)
    shadedErrorBar(year1,allVals_CO2a',{@mean,@std},'lineprops',colorVec{i,:},'patchSaturation',0.33);
    set(0,'CurrentFigure',h2)
    shadedErrorBar(year1,allVals_CO2error',{@mean,@std},'lineprops',colorVec{i,:},'patchSaturation',0.33);
    set(0,'CurrentFigure',h3)
    shadedErrorBar(year1,allVals_AGRdiff',{@mean,@std},'lineprops',colorVec{i,:},'patchSaturation',0.33);
   
end

set(0,'CurrentFigure',h1)
hold off
title('Modeled CO2a Ensembles')
legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
xlim([1850 2020]);
set(gca,'FontSize',18)
grid  
    
set(0,'CurrentFigure',h2)
hold off
title('Obs-Modeled CO2a Discrepancies')
hline = refline(0,[0,0]);
hline.LineStyle = ':';
legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
xlim([1850 2020]);
set(gca,'FontSize',18)
grid  

set(0,'CurrentFigure',h3)
hold off
title('Obs-Modeled AGR Difference')
hline = refline(0,[0,0]);
hline.LineStyle = ':';
legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
xlim([1850 2020]);
set(gca,'FontSize',18)
grid 
  

end
