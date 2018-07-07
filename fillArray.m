% saveParams2
% saveParams.m
%
% july 6, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)
% putting into tables (instead of saveParams.m)

function [outputArray] = fillArray(LU_i,Q1,eps,atmCalc2,obsCalcDiff,...
                                    outputArray,ddtUnfilt,ddtFilt,...
                                    RMSEunfilt,RMSEfilt)

load runInfo.mat

outputArray(LU_i+1,1) = LUdata(LU_i);
outputArray(LU_i+1,2) = {Q1};
outputArray(LU_i+1,3) = {eps};
outputArray(LU_i+1,4) = {atmCalc2};
outputArray(LU_i+1,5) = {obsCalcDiff};
outputArray(LU_i+1,6) = {ddtUnfilt};
outputArray(LU_i+1,7) = {ddtFilt};
outputArray(LU_i+1,8) = {RMSEunfilt};
outputArray(LU_i+1,9) = {RMSEfilt};

end

