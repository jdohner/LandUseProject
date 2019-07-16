% getCovCorr.m
%
% july 16, 2019
% 
% author: julia dohner
% 
% brief: calculates covariances and correlations between model result and 
% calculated land uptake

function [covariance,correlation] = getCovCorr(temp_anom,J,resid);

[N,P] = size(temp_anom);
covariance = inv(J(1:1177,:)'*J(1:1177,:))*sum(resid(1:1177,:).^2)/(N-P); 
[isize,jsize] = size(covariance);

for k=1:isize
    for x=1:jsize
        correlation(k,x) = covariance(k,x)/sqrt(covariance(k,k)*covariance(x,x));
    end
end

