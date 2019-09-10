% calcErrUncert.m
%
% sept 7, 2019
% 
% julia dohner
% 
% OUTPUTS:
% resid
% J
% cov & corr - between model result and calculated land uptake
% ci - uncertainties of best fit values
% MSE - goodness of fit between modeled and calculated
% error
% C - covariance of

function [MSE] = calcMSE(temp_anom,betahat,resid,Jacobian,ci,B_hat,filt_i,...
    scheme,year,B)
% B_hat is modeled land uptake (equivalent to yhat2)
% B is decon_resid calculated target

if strcmp(scheme,'aa') % filt/fit 1900-2015
    i = find(year(:,1) == 1900);
    i2 = find(year(:,1) == 2015);
elseif strcmp(scheme,'bb') % filt/fit 1958-2015
    i = find(year(:,1) == 1958);
    i2 = find(year(:,1) == 2015);
end
    
% look at MSE for 1900-2015
e = B_hat(i:i2)-B(i:i2,2);
misfit = e'*e/length(B_hat(i:i2));

MSE = immse(B_hat(i:i2),B(i:i2,2));


%% below not particularly useful

% error = +/- 1.95 stderr
% could be useful for extracting standard error
error = betahat(1)-ci(1);

% covariance between target and Bhat (another way of looking at goodness of
% it)
% 2x2 cov, computes 1. variance of decon_resid, 2. variance of yhat2, and
% 3. covariance between (1) and (2) to get 2x2 matrix
% but not particularly useful beacues not centered at 0
% this could perhaps be related to MSE, but AS doesn't think useful
C = cov(B(i:(end-1),2),B_hat(i:(end-1)));

% similar meaning to C, therefore also not that useful
[R,P,RLO,RUP] = corrcoef(B_hat(i:(end-1)),B(i:(end-1),2));

R(1,2)^2;


end



