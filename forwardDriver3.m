% forward model version 3
%
% creating to match LR fitted params for 2009+7/12
%
% march 21, 2018
% author: julia dohner, with code adapted from lauren rafelski

% testing/starting out ensembles_simplified branch

clear all; %close all

% which variable to loop through?
% A = land use (13 cases)
% N = generate new ensemble member (randomly pick from CO2a,FF,ocean)

vary = 'N';

nEnsemble = 10; % only used for vary = 'N' case

if strcmp(vary,'A')     numCases = 2;    
elseif strcmp(vary,'N') numCases = nEnsemble;
end


%% define time frame, cases

outputArray = cell(numCases+1,17);
outputArray(1,:) = {'Run Version','Q10','epsilon','gamma','input data',...
    'CO2a_model','obsCalcDiff','ddtUnfilt','ddtFilt','RMSEfilt 1900-2014'...
    'RMSEfilt 1958-2014','RMSEunfilt 1958-2014','C1dt','C2dt','delCdt',...
    'delC1','delC2'};

noisyCO2aRecords = cell(numCases+1,2);
noisyCO2aRecords(1,:) = {'Run Version','noisyCO2aRecord'};

if strcmp(vary,'K') % create array to hold land box flux values
    landFluxArray = cell(numCases,4);
    landFluxArray(1,:) = {'Run Version','C1dt','C2dt','delCdt'};
end

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
ts = 12; % timesteps per year
dt = 1/ts;
start_year = 1850;
start_yearOcean = 1800;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
co2_preind = 600/2.12; % around 283 ppm (preindustrial)


%% load data

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));


%% fitting parameters for cases

beta = [0.5;2]; % initial guesses for model fit (epsilon, q10)

for j = 1:numCases
    
% get the indices for variables being looped/held fixed    
[LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filt_i,...
    fert_i,oceanUp_i,photResp_i,zeroBio_i,Tstep_i,BLUE_i,ensemble_i,...
    rowLabels] = getLoopingVar(vary,j);


if tempDep_i == 2 || zeroBio_i == 4 % temp-independent
    beta = [0.5,1];
end

save('runInfo','start_year','end_year','ts','year','fert_i',...
    'oceanUp_i','tempDep_i','varSST_i','filt_i','rowLabels',...
    'opt_i','photResp_i','timeConst_i','zeroBio_i','Tstep_i','ensemble_i');


[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs,CO2a_obs_archive] = ...
getObservedCO2_2wNoise(ts,start_year,start_yearOcean,end_year,vary);


[temp_anom] = tempRecord4(Tstep_i,start_year,end_year,dt);

% calculate ocean sink from ff
if strcmp(vary,'N')
    [ff, LU] = getSourceSink6_wNoise(LU_i,BLUE_i,vary); % for updated FF & LU
    [fas,sstAnom] = jooshildascale_wNoise(start_year,start_yearOcean,end_year,ts,ff,varSST_i,Tconst,vary);
else
    [ff, LU] = getSourceSink6(LU_i,BLUE_i,vary); % for updated FF & LU
    [fas,sstAnom] = jooshildascale(start_year,end_year,ts,ff,varSST_i,Tconst);
end

save('ff','ff')

% Calculate residual land uptake
decon_resid0 = [year, dtdelpCO2a_obs(:,2)-ff(:,2)+Aoc*fas(:,2)-LU(:,2)];


%% calculate a 10-year running boxcar average of the residual land uptake
% don't use 10 year mean before 1957, because data are already smoothed
% (ice core)

[decon_resid] = applyFilter(filt_i, decon_resid0, end_year);
    
%% IMPORTANT PART - find model fit using a nonlinear regression 

i = find(decon_resid(:,1) == 1900);
[betahat,resid,J] = nlinfit(temp_anom,decon_resid(i:end,2),...
    'land_fitQs',beta);

% Look at covariances and correlations between model result and calculated land uptake 
[covariance,correlation] = getCovCorr(temp_anom,J,resid);

% Get uncertainties of best fit values
ci = nlparci(betahat,resid,J);


%% Redefine values of epsilon, gamma and Q1
if fert_i == 1   
    epsilon = betahat(1);
    gamma = 0;
    Q1 = betahat(2);
    Q2 = 1;
else % nitrogen fertilization
	epsilon = 0 ;
    gamma = betahat(1);
    Q1 = betahat(2);
    Q2 = 1;
end


%% plotting // fixing params here

% Run the best fit values in the model again to plot
[C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(epsilon,Q1,Q2,ts,year,...
    dpCO2a_obs,temp_anom,gamma,photResp_i,timeConst_i,zeroBio_i);


delCdt(:,2) = -delCdt(:,2); % change sign of land uptake


% TODO combine the two lines below
% 10 year moving boxcar average of model result
%[delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);

if filt_i == 1 % 10-yr filter applied
    [delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);
    yhat2 = delC10(:,2);
elseif filt_i == 2
    yhat2 = delCdt(:,2);   
end

%TODO: need filt_i == 3 case above??

% Do "reverse deconvolution" to calculate modeled CO2 change
i4 = find(fas(:,1) == start_year);
j4 = find(fas(:,1) == end_year);

% newat is the modeled dtdelpCO2a (CO2 increment with monthly resolution (ppm/year))
% a.k.a. atmospheric growth rate
dtdelpCO2a_model =  [year, ff(:,2) - Aoc*fas(:,2) + LU(:,2) + delCdt(:,2)];
CO2a_model = [year, co2_preind+cumsum(dtdelpCO2a_model(:,2)/12)];

co2_diff = [year,CO2a_obs(:,2)-CO2a_model(:,2)];
i6 = find(co2_diff(:,1) == 1959);
j6 = find(co2_diff(:,1) == 1979);
meandiff = mean(co2_diff(i6:j6,2)); % mean difference over 1959-1979
CO2a_model2 = CO2a_model(:,2)+meandiff; % TODO: make this [year2, CO2a_model(:,2)+meandiff]; will have to change var processing afterwards
% CO2a_model2 is formerly atmcalc2

obsCalcDiff = [year, CO2a_obs(:,2) - CO2a_model2(:,1)]; 

save('runOutput','CO2a_model2','obsCalcDiff','Q1','epsilon');

inputData = NaN;

C1dt = [C1dt(:,1), C1dt(:,2)*-1];
C2dt = [C2dt(:,1), C2dt(:,2)*-1];

[ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff);
[RMSEunfilt,RMSEfilt,RMSEfiltShort] = calcErrors(ddtUnfilt,ddtFilt);
[outputArray] = fillArray(j,Q1,epsilon,gamma,inputData,CO2a_model2,...
    obsCalcDiff,outputArray,ddtUnfilt,ddtFilt,RMSEunfilt,RMSEfiltShort,...
    RMSEfilt,C1dt,C2dt,delCdt,delC1,delC2);

if strcmp(vary,'N')
    noisyCO2aRecords(j+1,1) = rowLabels(j);
    noisyCO2aRecords(j+1,2) = {CO2a_obs};
end


end

plotEnsembles(outputArray, numCases,vary,year);

% saving the output array
outputArray

% plotting output similar to LR figure 5 & 7
run1 = 1;
run2 = 2;
plotvsObs(run1,run2,outputArray, CO2a_obs,year);


