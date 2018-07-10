% Things to check: end year defined correctly? line 12
% beta variables defined correctly? lines 22-32
% correct model chosen? lines 36-43
% correct time period for yhat? line 55

function yhat = tempDep_land_fit_Qs(beta,temp_anom)

load runInfo.mat
load decon_resid.mat


% Get parameters
[dtdelpCO2a,dpCO2a,~,~,CO2a] = getObservedCO2_2(ts,start_year,end_year);

% To make temperature-independent: set Q1 and Q2 to 1

if strcmp(fert,'co2')
    % For CO2 fertilization model
    epsilon = beta(1);
    Q1 = beta(2);
    Q2 = 1;
    
    [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo_sub10(epsilon,Q1,Q2,ts,year,dpCO2a,temp_anom); 
else 
    % For N fertilization model
    epsilon = 0;
    gamma = beta(1);
    Q1 = beta(2);
    Q2 = 1; 
    [fas,ff,LU,LUex] = getSourceSink3(year2,ts);
    [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo_subN(epsilon,Q1,Q2,gamma,ff(601:end,:),ts,year,dpCO2a,temp_anom);
end
% get modeled fluxes into boxes out from above loop
    
delCdt(:,2) = -delCdt(:,2); 

% 10-year moving boxcar average of model
[delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);
%[delC10] = boxcar2(delCdt,10,12,1,length(delCdt),1,2);

% yhat is the term that is compared to the residual flux in nlinfit. 
% Change the index numbers here and in nonlin_land_Qs_annotate (e.g. line
% 158) to fit to a different time period

%% messing with fitting timeframes

yhat0 = decon_resid;

[timeFrameVec] = getTimeFrame(timeFrame,year);

% shorten timeFrameVec to match length of delC10 coming out of boxcar
m = find(timeFrameVec == delC10(end,1));
timeFrameVec = timeFrameVec(1:m,:);

% get the indices of values to include in fit
k = find(timeFrameVec(:,2)); %returns indices of non-zero elements

% it's going over the dimensions of yhat because yhat is defined by
% decon_resid, which has gone through l_boxcar. That's problematic because
% teh boxcar filtering shortens the record by 5 years at the end, even if
% we'd want to include the last 5 years in the fit
for k2 = 1:length(k)
     % making all places with 1s be part of fit
    yhat0(k2,2) = delC10(k2,2);
end

yhat = yhat0(:,2); % needs to be 1927x1 for nlinfit to match either decon
% or T_anom, both of which are presumably clipped at 1900. undo the
% clipping
    