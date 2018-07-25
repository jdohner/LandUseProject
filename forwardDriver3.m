% forward model version 3
%
% creating to match LR fitted params for 2009+7/12
%
% march 21, 2018
% author: julia dohner, with code adapted from lauren rafelski



clear all

%% define time frame, cases

% LU datasets
% 1 = hough
% 2 = hansis
% 3 = hough03
% 4 = const
% 5 = const2
% 6 = gcp
% 7 = hough03 extratrop
% 8 = CABLE from GCP
% 9 = CABLE higher, includes C loss from grazing & harvest
% 10 = LPX-Bern HYDE
% 11 = LPX-Bern LUH
% 12 = ORCHIDEE-MICT
% 13 = OC-N
% 14 = CLM4.5
% 15 = Yue et al. (2018)
% 16 = Yue et al. (2018) without age dynamics



% optimization period
% a = 1900-2010.5 (can't go past 5 years before end of data)
% b = 1900-2005.5
% c = 1950-1980
% d = 1900-2000.5 % should theoretically match output from end_year
% = 2005.5 in old code

% temperature record
% I = HadCRUT4_2018_05
%   Combined land [CRUTEM4] and marine [SST anomalies from HadSST3] 
%   temperature anomalies on a 5° by 5° grid (Morice et al., 2012)
%
% II = CRUTEM4_2018_05
%   Land air temperature anomalies on a 5° by 5° grid (Jones et al., 2012)
%
% III = CRUTEM4v
%   Variance adjusted version of CRUTEM4
%
% IV = Nino 3.4 index
%   ESRL/NOAA Nino 3.4, 1870-present based on HadISST
%
% V = tropical T
%   Following Wang et al. (2014)
%   N/A
%
% VI = Global Historical Climate Network 
%   N/A
% 
% VII = MLOST 3.5 from NOAA
%   Currently unable to access data
%   N/A
%
% VIII = temp record from LR/my attempts to match LR (use for debugging)
%   landwt_T_2011.mat combined with CRUTEM4
%


% update variable sst data file
% HadSST3
%   Sea surface temperature anomalies on a 5° by 5° grid (Kennedy et al., 2011)


timeFrame = 'a'; % picking time frame over which parameters are fit
tempRecord = 'VIII';

numCases = 13;
LUname = {'Houghton 2017';'Hansis 2015';'Houghton 2003';'Constant';...
    'Constant*2';'GCP';'Houghton 2003 low';...
    'CABLE';'CABLE high';'LPX HYDE';'LPX LUH';'ORCHIDEE-MICT';'OC-N';...
    'CLM45';'Yue 2018';'Yue 2018 noAge'};
outputArray = cell(numCases+1,10);
outputArray(1,:) = {'LUname','LUdata','Q10','eps','atmcalc2','obsCalcDiff',...
    'ddtUnfilt','ddtFilt','RMSEunfilt','RMSEfilt'};
    
oceanUptake = 2; % scaling ocean sink by +/- 30% : low = 1, medium = 2, high = 3;   
tempDep = 1; % 1 for variable T, 0 for fixed T;
varSST = 0; %1 if variable sst, 0 if fixed sst
fert = 'co2'; % co2 or nitrogen fertilization
filter = 1; % filter the data? 1 = 10 year filter; 2 = unfiltered


Tconst = 18.2; % surface temperature, deg C, from Joos 1996
ts = 12; % timesteps per year
dt = 1/ts;
start_year = 1850;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
beta = [0.5;2]; % initial guesses for model fit (epsilon, q10)
if tempDep == 0
    beta = [0.5,1];
end
co2_preind = 600/2.12; % around 283 ppm (preindustrial)


save('runInfo','start_year','end_year','ts','year','fert',...
    'oceanUptake','tempDep','varSST','filter',...
    'LUname','timeFrame');

%% load data

% give access to data files in co2_forward_data folder
% addpath(genpath(...
%     '/Users/juliadohner/Documents/MATLAB/JLDedits_Rafelski_LandOceanModel/v3_params_match/necessary_data'))';

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));
% for debugging, getObservedCO2_2 for when trying to match OG LR code
% output
%[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);
%[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_3(ts,start_year,end_year);
[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);

%% get temp record

% temp_full covers 1850-2017+(9/12)
% temp_anom comes out at 1850-2015.5
%[temp_anom, ~] = tempRecord2(start_year,end_year,dt);
[temp_anom] = tempRecord3(tempRecord,start_year,end_year,dt);

%% fitting parameters for cases



for LU_i = 1:numCases
    
[ff, LU] = getSourceSink5(year, ts,LU_i); % for updated FF & LU

[fas,sstAnom] = jooshildascale(start_year,end_year,ts,ff,varSST,Tconst);

% scaling ocean uptake
if oceanUptake == 3 % high ocean uptake
    fas(:,2) = fas(:,2)*1.3;
    %disp('ocean multiplied by 1.3')
elseif oceanUptake == 1 % low ocean uptake
        fas(:,2) = fas(:,2)*0.7;
     %   disp('ocean multiplied by 0.7')
else
    %disp('ocean not multiplied')
end

% Calculate residual land uptake
decon_resid0 = [year, dtdelpCO2a_obs(:,2)-ff(:,2)+Aoc*fas(:,2)-LU(:,2)];


%% calculate a 10-year running boxcar average of the residual land uptake
% don't use 10 year mean before 1957, because data are already smoothed
% (ice core)

if filter == 1 
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    j = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_resid(1:j,:) = decon_resid0(1:j,:);
    decon_resid((j+1):(length(decon_filt0)),:) = decon_filt0((j+1):end,:);

else 
    % shorten unfiltered record
    j = find(decon_resid(:,1) == end_year-5);
    decon_resid = decon_resid(1:j,:);    
end

% decon_resid is 5 years shorter than full record
save('decon_resid','decon_resid');
    

%% IMPORTANT PART - find model fit using a nonlinear regression 

i = find(decon_resid(:,1) == 1900);
[betahat,resid,J] = nlinfit(temp_anom,decon_resid(i:end,2),...
    'land_fitQs',beta);


% debugging code
% 
% i = find(decon_resid(:,1) == 1900);
% j = find(decon_resid(:,1) == 2000.5);
% [betahat,resid,J] = nlinfit(temp_anom,decon_resid(i:j,2),...
%     'land_fitQs',beta);
% 
% Q1 = betahat(2)

%% Look at covariances and correlations between model result and calculated land uptake 

[N,P] = size(temp_anom);
covariance = inv(J(1:1177,:)'*J(1:1177,:))*sum(resid(1:1177,:).^2)/(N-P); 
[isize,jsize] = size(covariance);

for k=1:isize
    for j=1:jsize
        correlation(k,j) = covariance(k,j)/sqrt(covariance(k,k)*covariance(j,j));
    end
end

% Get uncertainties of best fit values
ci = nlparci(betahat,resid,J);


%% Redefine values of epsilon, gamma and Q1
if strcmp(fert,'co2')    
    epsilon = betahat(1);
    Q1 = betahat(2);
    Q2 = 1;
else % nitrogen fertilization
	epsilon = 0 ;
    gamma = betahat(1);
    Q1 = betahat(2);
    Q2 = 1;
end


%% plotting // fixing params here

if end_year ~= end_year
    [dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_3(ts,start_year,end_year);
    [temp_anom, ~] = tempRecord2(start_year,end_year,dt);
    [ff, LU] = getSourceSink5(year, ts, LU_i); % for updated FF & LU
    [fas,sstAnom] = jooshildascale_annotate2(start_year,end_year,ts,ff,varSST,Tconst);
end

% Run the best fit values in the model again to plot
if strcmp(fert,'co2')
    [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo_sub10(...
        epsilon,Q1,Q2,ts,year,dpCO2a_obs,temp_anom); 
else % N fertilization
    [C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo_subN(...
        epsilon,Q1,Q2,gamma,ff,ts,year,dpCO2a,temp_anom);
end
delCdt(:,2) = -delCdt(:,2); % change sign of land uptake

% 10 year moving boxcar average of model result
[delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);

if filter == 1 
    yhat2 = delC10(:,2);
else
    yhat2 = delCdt(:,2);   
end

% Do "reverse deconvolution" to calculate modeled CO2 change
i4 = find(fas(:,1) == start_year);
j4 = find(fas(:,1) == end_year);

newat =  [year, ff(:,2) - Aoc*fas(:,2) + LU(:,2) + delCdt(:,2)];
atmcalc = [year, co2_preind+cumsum(newat(:,2)/12)];

co2_diff = [year,CO2a_obs(:,2)-atmcalc(:,2)];
i6 = find(co2_diff(:,1) == 1959);
j6 = find(co2_diff(:,1) == 1979);
meandiff = mean(co2_diff(i6:j6,2)); % mean difference over 1959-1979
atmcalc2 = atmcalc(:,2)+meandiff; % TODO: make this [year2, atmcalc(:,2)+meandiff]; will have to change var processing afterwards

obsCalcDiff = [year, CO2a_obs(:,2) - atmcalc2(:,1)]; 

save('runOutput','atmcalc2','obsCalcDiff','Q1','epsilon');

% call plotting function
% getDriverPlots(varSST,CO2a_obs,year,atmcalc2,year,temp_anom,...
%    sstAnom,decon_resid,delC10,yhat2,LU,ff,fas,Aoc,obsCalcDiff)

% call parameter-saving function 
% saveParams(tempDep,end_year,end_year_plot,landusedata,atmcalc2,...
    %obsCalcDiff,Q1,epsilon,year)
    
[ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff);
[RMSEunfilt,RMSEfilt] = calcErrors(ddtUnfilt,ddtFilt);
[outputArray] = fillArray(LU,LU_i,Q1,epsilon,atmcalc2,obsCalcDiff,outputArray,...
    ddtUnfilt,ddtFilt,RMSEunfilt,RMSEfilt);

end


%% saving the output array


% function to save parameters in appropriate file name
[outputArray] = saveParams(outputArray)



