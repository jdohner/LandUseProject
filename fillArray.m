% saveParams2
% saveParams.m
%
% july 6, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)
% putting into tables (instead of saveParams.m)

function [outputArray] = fillArray(j,Q1,eps,atmCalc2,obsCalcDiff,...
                                    outputArray,ddtUnfilt,ddtFilt,...
                                    RMSEunfilt,RMSEfilt)

load runInfo.mat

outputArray(j+1,1) = rowLabels(j);
outputArray(j+1,2) = {Q1};
outputArray(j+1,3) = {eps};
outputArray(j+1,4) = {atmCalc2};
outputArray(j+1,5) = {obsCalcDiff};
outputArray(j+1,6) = {ddtUnfilt};
outputArray(j+1,7) = {ddtFilt};
outputArray(j+1,8) = {RMSEunfilt};
outputArray(j+1,9) = {RMSEfilt};

end

