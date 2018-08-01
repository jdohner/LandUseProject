% land_fitQs.m
%
% july 10, 2018
% julia dohner
%
% recombining the tempdep and tempindep land_fit_Qs functions


function yhat = land_fitQs(beta,temp_anom)

load runInfo.mat
load decon_resid.mat


% Get parameters
[dtdelpCO2a,dpCO2a,~,~,CO2a] = getObservedCO2_2(ts,start_year,end_year);

if fert_i == 1 % CO2 fert
    epsilon = beta(1);
    gamma = 0;
else % N fert
    epsilon = 0;
    gamma = beta(1);
end

if tempDep_i == 1 % to make temp indep, set Q1 = 1
    Q1 = beta(2);
else
    Q1 = 1;
end

Q2 = 1; 


[C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(epsilon,Q1,Q2,ts,year,...
    dpCO2a,temp_anom,gamma,photResp_i,timeConst_i);


% get modeled fluxes into boxes out from above loop
    
delCdt(:,2) = -delCdt(:,2); 

% 10-year moving boxcar average of model
[delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);
%[delC10] = boxcar2(delCdt,10,12,1,length(delCdt),1,2);

% yhat is the term that is compared to the residual flux in nlinfit. 
% Change the index numbers here and in nonlin_land_Qs_annotate (e.g. line
% 158) to fit to a different time period

%% messing with fitting timeframes

i = find(decon_resid == 1900);
yhat0 = decon_resid(i:end,:);

% timeFrameVec goes 1850-2015.5 (1987x2)
[timeFrameVec] = getTimeFrame(opt_i,year);

save('timeFrameVec','timeFrameVec');

% shorten timeFrameVec to match length of delC10 coming out of boxcar
l = find(timeFrameVec == 1900);
m = find(timeFrameVec == delC10(end,1));
timeFrameVec = timeFrameVec(l:m,:);

% get the indices of non-zero values to include in fit
k = find(timeFrameVec(:,2));

j = find(delC10(:,1) == 1900);
delC10_cut = delC10(j:end,:);

for k2 = 1:length(k)
    % all places with 1s become part of fit
    yhat0(k2,2) = delC10_cut(k2,2);
end

yhat = yhat0(:,2);

% %% debugging code
% % seeing if using a shorter vector (only thru 2005.5 instead of full
% % vector but with zeros at the end) influences the output Q1 value. it
% % doesnt.
% 
% i = find(decon_resid == 1900);
% j = find(decon_resid == 2000.5);
% yhat0 = decon_resid(i:j,:);
% 
% % timeFrameVec goes 1850-2015.5 (1987x2)
% [timeFrameVec] = getTimeFrame(timeFrame,year);
% 
% % shorten timeFrameVec to match length of delC10 coming out of boxcar
% l = find(timeFrameVec == 1900);
% m = find(timeFrameVec == 2000.5);
% timeFrameVec = timeFrameVec(l:m,:);
% 
% % get the indices of non-zero values to include in fit
% k = find(timeFrameVec(:,2));
% 
% j = find(delC10(:,1) == 1900);
% h = find(delC10(:,1) == 2000.5);
% delC10_cut = delC10(j:h,:);
% 
% for k2 = 1:length(k)
%     % all places with 1s become part of fit
%     yhat0(k2,2) = delC10_cut(k2,2);
% end
% 
% yhat = yhat0(:,2);
%     