% calcSigma.m
%
% sept 2, 2019
%
% author: julia dohner

function [sigmaCO2error,sigmaAGRdiff] = calcSigma(allVals_CO2error,allVals_AGRdiff)

sigmaCO2error = zeros(length(allVals_CO2error),1);
sigmaAGRdiff = zeros(length(allVals_AGRdiff),1);

for i = 1:length(allVals_CO2error)
    sigmaCO2error(i) = std(allVals_CO2error(i,:));
    sigmaAGRdiff(i) = std(allVals_AGRdiff(i,:));

end

end