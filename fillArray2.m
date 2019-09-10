% saveParams2
% saveParams.m
%
% july 6, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)
% putting into tables (instead of saveParams.m)

function [outputArray] = fillArray2(j)



load runInfo.mat
load allVars

if strcmp(vary,'N')
    number = int2str(j);
    outputArray(j+1,1) = {strcat('Member',number)};
else 
    outputArray(j+1,1) = rowLabels(j);
end
outputArray(j+1,2) = {Q1};
outputArray(j+1,3) = {epsilon};
outputArray(j+1,4) = {gamma};
outputArray(j+1,5) = {inputData};
outputArray(j+1,6) = {atmCalc2};
outputArray(j+1,7) = {obsCalcDiff};
outputArray(j+1,8) = {ddtUnfilt};
outputArray(j+1,9) = {ddtFilt};
outputArray(j+1,10) = {RMSEfilt};
outputArray(j+1,11) = {RMSEfiltShort};
outputArray(j+1,12) = {RMSEunfilt};
outputArray(j+1,13) = {C1dt};
outputArray(j+1,14) = {C2dt};
outputArray(j+1,15) = {delCdt};
outputArray(j+1,16) = {delC1}; %change in fast box size since 1850
outputArray(j+1,17) = {delC2}; %change in slow box size since 1850
outputArray(j+1,18) = {dtdelpCO2a_model};
outputArray(j+1,19) = {AGR_model_filt};
%outputArray(j+1,20) = {delC10};


end

