% saveParams2
% saveParams.m
%
% july 6, 2018
%
% script to package and output parameters from forwardDriver fitting 
% (epsilon and Q10)
% putting into tables (instead of saveParams.m)

function [outputArray] = fillArray(LU,LU_i,Q1,eps,atmCalc2,obsCalcDiff,...
                                    outputArray,ddtUnfilt,ddtFilt,...
                                    RMSEunfilt,RMSEfilt)

load runInfo.mat

outputArray(LU_i+1,1) = LUname(LU_i);
outputArray(LU_i+1,2) = {LU};
outputArray(LU_i+1,3) = {Q1};
outputArray(LU_i+1,4) = {eps};
outputArray(LU_i+1,5) = {atmCalc2};
outputArray(LU_i+1,6) = {obsCalcDiff};
outputArray(LU_i+1,7) = {ddtUnfilt};
outputArray(LU_i+1,8) = {ddtFilt};
outputArray(LU_i+1,9) = {RMSEunfilt};
outputArray(LU_i+1,10) = {RMSEfilt};

end

