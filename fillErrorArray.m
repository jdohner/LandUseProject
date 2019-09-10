% fillEnsembleErrArray.m
%
% sept 7 2019
%
% author: julia dohner
%
% fills cell array with relevant values for LU ensemble runs

function [errorArray] = fillErrorArray(j,vary,errorArray,rowLabels,...
    cov,corr,Jacobian,resid,ci,MSE)

load runInfo.mat

if strcmp(vary,'N')
    number = int2str(j);
    errorArray(j+1,1) = {strcat('Member',number)};
else 
    errorArray(j+1,1) = rowLabels(j);
end
errorArray(j+1,2) = {cov};
errorArray(j+1,3) = {corr};
errorArray(j+1,4) = {Jacobian};
errorArray(j+1,5) = {resid};
errorArray(j+1,6) = {ci};
errorArray(j+1,7) = {MSE};


end