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

% To make temperature-independent: set Q1 and Q2 to 1


if strcmp(fert,'co2')
    % For CO2 fertilization model
    epsilon = beta(1);
    Q2 = 1;
    
        % to make temp indep, set Q1 = 1
    if tempDep == 1
        Q1 = beta(2)
    else
        Q1 = 1;
    end

    
    [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo_sub10(epsilon,Q1,Q2,ts,year,dpCO2a,temp_anom); 
else 
    % For N fertilization model
    epsilon = 0;
    gamma = beta(1);
    Q2 = 1; 
    
    % to make temp indep, set Q1 = 1
    if tempDep == 1
        Q1 = beta(2)
    else
        Q1 = 1;
    end
    
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

% up to this point delC10 matches old (after boxcar) - goes to 2010.5

i = find(decon_resid == 1900);
yhat0 = decon_resid(i:end,:);

% timeFrameVec goes 1850-2015.5 (1987x2)
[timeFrameVec] = getTimeFrame(timeFrame,year);
% everything else (decon_resid, delC10) is 1850 to 2010.5 (1927x1)

% shorten timeFrameVec to match length of delC10 coming out of boxcar
l = find(timeFrameVec == 1900);
m = find(timeFrameVec == delC10(end,1));
timeFrameVec = timeFrameVec(l:m,:);
% becomes 1327x2 (1900 to 2010.5)

% get the indices of values to include in fit
k = find(timeFrameVec(:,2)); %returns indices of non-zero elements

% it's going over the dimensions of yhat because yhat is defined by
% decon_resid, which has gone through l_boxcar. That's problematic because
% teh boxcar filtering shortens the record by 5 years at the end, even if
% we'd want to include the last 5 years in the fit

j = find(delC10 == 1900);
delC10_cut = delC10(j:end,:);

%yhat0 and delC10 are different lengths
for k2 = 1:length(k)
     % making all places with 1s be part of fit
    yhat0(k2,2) = delC10_cut(k2,2);
end

yhat = yhat0(:,2); % needs to be 1927x1 for nlinfit to match either decon
% or T_anom, both of which are presumably clipped at 1900. undo the
% clipping

%^^something there is broken

%yhat = delC10(601:end,2);
    