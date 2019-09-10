% getCovCorr.m
%
% july 16, 2019
% 
% author: julia dohner
% 
% brief: calculates covariances and correlations between model result and 
% calculated land uptake

function [covariance,correlation] = getCovCorr(temp_anom,J,resid,year_fitted);

[N,P] = size(temp_anom);

i1 = find(year_fitted(:,1) == 1900);
i2 = find(year_fitted(:,1) == 1998);

% corresponds to years 1900 and 1998, but J doesn't align with year vector
% check this on Tuesday
% J starts at 1900 
covariance = inv(J(i1:i2,:)'*J(i1:i2,:))*sum(resid(i1:i2,:).^2)/(N-P); 
%covariance = inv(J(1:1177,:)'*J(1:1177,:))*sum(resid(1:1177,:).^2)/(N-P); 
[isize,jsize] = size(covariance);

for k=1:isize
    for x=1:jsize
        correlation(k,x) = covariance(k,x)/sqrt(covariance(k,k)*covariance(x,x));
    end
end

