% fillLandFluxArray.m
%
% julia dohner
% august 29, 2018

function [landFluxArray] = fillLandFluxArray(landFluxArray,j,C1dt,C2dt,delCdt)

load runInfo.mat

landFluxArray(j+1,1) = rowLabels(j);
landFluxArray(j+1,2) = {C1dt}; % fast box uptake
landFluxArray(j+1,3) = {C2dt}; % slow box uptake
landFluxArray(j+1,4) = {delCdt}; % total box uptake



end