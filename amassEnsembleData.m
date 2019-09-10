% amassEnsembleData.m
%
% september 2, 2019
%
% author: julia dohner

% can amass AGR diff data or CO2 diff data

function [allVals_CO2a,allVals_CO2error,allVals_AGRdiff] = ...
    amassEnsembleData(outputArray,numCases,AGRobs_filt,year)

% compile all CO2a and AGR error values
blankVec = zeros(length(year),numCases);
allVals_CO2a = blankVec;
allVals_CO2error = blankVec;
allVals_AGRdiff = blankVec;
allVals_MSE = blankVec;

for j = 1:numCases
    allVals_CO2a(:,j) = outputArray{j+1,6};

    obsCalcDiff = outputArray{j+1,7};
    allVals_CO2error(:,j) = obsCalcDiff(:,2);

    % dtdelpCO2a_model is calculated from yhat2 therefore is filtered
    dtdelpCO2a_model = outputArray{j+1,18};
    allVals_AGRdiff(:,j) = dtdelpCO2a_model(:,2)-AGRobs_filt(:,2);
    
    
end


% amassedEnsembleData = zeros(length(year),nEnsemble+1));
% amassedEnsembleData(:,1) = year;
% 
% for i = 1:nEnsemble
%     
%     % want differences
%     amassedEnsembleData(:,i+1) = outputArray{i+1,18};
%     
%     dtdelpCO2a_model = outputArray{j+1,18};
% 
% outputArray = cell(numCases+1,19);
% outputArray(1,:) = {'Run Version','Q10','epsilon','gamma','input data',...
%     'CO2a_model','obsCalcDiff','ddtUnfilt','ddtFilt','RMSEfilt 1900-2014'...
%     'RMSEfilt 1958-2014','RMSEunfilt 1958-2014','C1dt','C2dt','delCdt',...
%     'delC1','delC2','dtdelpCO2a_model','AGR_model_filt'};


end

