% plotEnsembles.m
%
% julia dohner
% july 24, 2018

function plotEnsembles(LUensembleArray,nLU,scheme)

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/MATLAB_toolkits'));

h1 = figure('Name','Modeled CO2a Ensembles');
h2 = figure('Name','Obs-Calc CO2a Difference');
h3 = figure('Name','Obs-Calc AGR Difference');
legendInfo = {};
%colorVec = hsv(nLU);
colorVec = {'-g';'-b';'-r';'-y'};
hold all

ts = 12;
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5;
vary = 'A'; % don't get noisy AGR record for comparison
[dtdelpCO2a_obs,~,~,~,~,~] = ... % in ppm
    getObservedCO2_2wNoise(ts,start_year,start_yearOcean,end_year,vary);

% apply 10-year filter on observed AGR

if strcmp(scheme,'aa')
    AGRobs_filt = l_boxcar(dtdelpCO2a_obs,10,12,1,length(dtdelpCO2a_obs(:,2)),1,2);    
    
elseif strcmp(scheme,'bb')
    i = find(dtdelpCO2a_obs(:,1) >= 1952,1);
    k = find(dtdelpCO2a_obs(:,1) >= (1956+(11/12)),1);

    [AGRobs_filt0] = l_boxcar(dtdelpCO2a_obs,10,12,i,length(dtdelpCO2a_obs),1,2);
    AGRobs_filt(1:k,:) = AGRobs_filt0(1:k,:);
    AGRobs_filt((k+1):(length(AGRobs_filt0)),:) = AGRobs_filt0((k+1):end,:);
    
end



for i = 1:nLU
    legendInfo{i} = LUensembleArray{i+1,1};
    outputArray = LUensembleArray{i+1,2};
    % errorArray = LUensembleArray{i+1,3};
    numCases = LUensembleArray{i+1,4};
    year = LUensembleArray{i+1,5};
    
    year1 = year';


    
    [allVals_CO2a,allVals_CO2error,allVals_AGRdiff] = ...
        amassEnsembleData(outputArray,numCases,AGRobs_filt,year);
    
    [sigmaCO2error,sigmaAGRdiff] = calcSigma(allVals_CO2error,allVals_AGRdiff);
    
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
ylabel('ppm CO2','FontSize',18)
if strcmp(scheme,'aa')
    xlim([1900 2020]);
elseif strcmp(scheme,'bb')
    xlim([1958 2020])
end
set(gca,'FontSize',18)
grid  
    
set(0,'CurrentFigure',h2)
hold off
title('Obs-Modeled CO2a Discrepancies')
hline = refline(0,[0,0]);
hline.LineStyle = ':';
legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
ylabel('ppm CO2','FontSize',18)
if strcmp(scheme,'aa')
    xlim([1900 2020]);
elseif strcmp(scheme,'bb')
    xlim([1958 2020])
end
set(gca,'FontSize',18)
grid  

set(0,'CurrentFigure',h3)
hold off
title('Obs-Modeled AGR Difference')
hline = refline(0,[0,0]);
hline.LineStyle = ':';
legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
ylabel('ppm CO2/year','FontSize',18)
if strcmp(scheme,'aa')
    xlim([1900 2020]);
elseif strcmp(scheme,'bb')
    xlim([1958 2020])
end
set(gca,'FontSize',18)
grid 
  

end
