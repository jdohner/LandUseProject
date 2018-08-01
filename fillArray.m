% saveParams2
% saveParams.m
%
% july 6, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)
% putting into tables (instead of saveParams.m)

function [outputArray] = fillArray(j,Q1,epsilon,gamma,inputData,...
                                    atmCalc2,obsCalcDiff,outputArray,...
                                    ddtUnfilt,ddtFilt,RMSEunfilt,RMSEfilt)

load runInfo.mat

outputArray(j+1,1) = rowLabels(j);
outputArray(j+1,2) = {Q1};
outputArray(j+1,3) = {epsilon};
outputArray(j+1,4) = {gamma};
outputArray(j+1,5) = {inputData};
outputArray(j+1,6) = {atmCalc2};
outputArray(j+1,7) = {obsCalcDiff};
outputArray(j+1,8) = {ddtUnfilt};
outputArray(j+1,9) = {ddtFilt};
outputArray(j+1,10) = {RMSEunfilt};
outputArray(j+1,11) = {RMSEfilt};

end

