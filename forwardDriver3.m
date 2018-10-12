% forward model version 3
%
% creating to match LR fitted params for 2009+7/12
%
% march 21, 2018
% author: julia dohner, with code adapted from lauren rafelski



clear all; %close all

% which variable to loop through?
% A = land use (13 cases)
% B = optimization time frame (4 cases)
% C = temperature record (4 cases)
% D = fixed vs var T (2 cases)
% E = fixed vs var SST (2 cases)
% F = values for fast box time constant (6 cases)
% G = filtering of residual from deconvolution (3 cases)
% H = ocean uptake
% I = co2 vs N fert
% J = t-dependent photosynthesis or respiration
% K = loop through cancelling out eps, ?Ci

vary = 'G';

if strcmp(vary,'A')     numCases = 13;    
elseif strcmp(vary,'B') numCases = 4;
elseif strcmp(vary,'C') numCases = 4;
elseif strcmp(vary,'D') numCases = 2;    
elseif strcmp(vary,'E') numCases = 2;    
elseif strcmp(vary,'F') numCases = 5;
elseif strcmp(vary,'G') numCases = 5;
elseif strcmp(vary,'H') numCases = 3;
elseif strcmp(vary,'I') numCases = 2;
elseif strcmp(vary,'J') numCases = 2;
elseif strcmp(vary,'K') numCases = 4;
else % see README for cases
    numCases = 1;
    LU_i = 1;
    opt_i = 1;
    Tdata_i = 1;
    tempDep_i = 1;
    varSST_i = 1;
    timeConst_i = 1;
    filt_i = 1;
    fert_i = 1;
    oceanUp_i = 1;
    photResp_i = 1;
    zeroBio_i = 1;
end


%% define time frame, cases

outputArray = cell(numCases+1,12);
outputArray(1,:) = {'Run Version','Q10','epsilon','gamma','input data',...
    'atmcalc2','obsCalcDiff','ddtUnfilt','ddtFilt','RMSEfilt 1900-2014'...
    'RMSEfilt 1958-2014','RMSEunfilt 1958-2014'};

if strcmp(vary,'K') % create array to hold land box flux values
    landFluxArray = cell(numCases,4);
    landFluxArray(1,:) = {'Run Version','C1dt','C2dt','delCdt'};
end

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
ts = 12; % timesteps per year
dt = 1/ts;
start_year = 1850;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
co2_preind = 600/2.12; % around 283 ppm (preindustrial)


%% load data

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));

[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);


%% fitting parameters for cases

beta = [0.5;2]; % initial guesses for model fit (epsilon, q10)
saveInputData; % load and process FF and LU data

for j = 1:numCases
    
% get the indices for variables being looped/held fixed    
[LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filt_i,...
    fert_i,oceanUp_i,photResp_i,zeroBio_i,rowLabels] = getLoopingVar(vary,j);


if tempDep_i == 2 % temp-independent
    beta = [0.5,1];
end

save('runInfo','start_year','end_year','ts','year','fert_i',...
    'oceanUp_i','tempDep_i','varSST_i','filt_i',...
    'rowLabels','opt_i','photResp_i','timeConst_i','zeroBio_i');

[temp_anom] = tempRecord3(Tdata_i,start_year,end_year,dt);
    
[ff, LU] = getSourceSink6(LU_i); % for updated FF & LU

save('ff','ff')

[fas,sstAnom] = jooshildascale(start_year,end_year,ts,ff,varSST_i,Tconst);

% scaling ocean uptake
if oceanUp_i == 3 % high
    fas(:,2) = fas(:,2)*1.3;
elseif oceanUp_i == 2 % low
        fas(:,2) = fas(:,2)*0.7;
end

% Calculate residual land uptake
decon_resid0 = [year, dtdelpCO2a_obs(:,2)-ff(:,2)+Aoc*fas(:,2)-LU(:,2)];


%% calculate a 10-year running boxcar average of the residual land uptake
% don't use 10 year mean before 1957, because data are already smoothed
% (ice core)

if filt_i == 1 % 10-year filter
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);
    
elseif filt_i == 2 % 1-year filter
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,1,12,i,length(decon_resid0),1,2);
    decon_resid(1:k,:) = decon_resid0(1:k,:);
    decon_resid((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);   

elseif  filt_i == 3 % unfiltered
    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_resid = decon_resid0(1:k,:);    

elseif filt_i == 4 % unfilt - filt 10-year
    
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,10,12,i,length(decon_resid0),1,2);
    decon_residFilt(1:k,:) = decon_resid0(1:k,:);
    decon_residFilt((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);

    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_residUnfilt = decon_resid0(1:k,:);  
    
    % difference (only the high-freq noise)
    decon_resid = [decon_residUnfilt(:,1) , ...
        decon_residUnfilt(:,2)-decon_residFilt(:,2)];
    
elseif filt_i == 5 % unfilt - filt 1-year
    
    % using filtered data for everything after 
    i = find(decon_resid0(:,1) == 1952);
    k = find(decon_resid0(:,1) >= (1956+(11/12)),1);

    [decon_filt0] = l_boxcar(decon_resid0,1,12,i,length(decon_resid0),1,2);
    decon_residFilt(1:k,:) = decon_resid0(1:k,:);
    decon_residFilt((k+1):(length(decon_filt0)),:) = decon_filt0((k+1):end,:);

    % shorten unfiltered record
    k = find(decon_resid0(:,1) == end_year-5);
    decon_residUnfilt = decon_resid0(1:k,:);  
    decon_residFilt = decon_residFilt(1:k,:);
    
    % difference (only the high-freq noise)
    decon_resid = [decon_residUnfilt(:,1) , ...
        decon_residUnfilt(:,2)-decon_residFilt(:,2)];
    
    

end


% decon_resid is 5 years shorter than full record
save('decon_resid','decon_resid');
    

%% IMPORTANT PART - find model fit using a nonlinear regression 

i = find(decon_resid(:,1) == 1900);
[betahat,resid,J] = nlinfit(temp_anom,decon_resid(i:end,2),...
    'land_fitQs',beta);

%% Look at covariances and correlations between model result and calculated land uptake 

[N,P] = size(temp_anom);
covariance = inv(J(1:1177,:)'*J(1:1177,:))*sum(resid(1:1177,:).^2)/(N-P); 
[isize,jsize] = size(covariance);

for k=1:isize
    for x=1:jsize
        correlation(k,j) = covariance(k,x)/sqrt(covariance(k,k)*covariance(x,x));
    end
end

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

% if end_year ~= end_year
%     [dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_3(ts,start_year,end_year);
%     [temp_anom] = tempRecord3(Tdata_i,start_year,end_year,dt);
%     [ff, LU] = getSourceSink5(year, ts, LU_i); % for updated FF & LU
%     [fas,sstAnom] = jooshildascale_annotate2(start_year,end_year,ts,ff,varSST,Tconst);
% end

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

% consolidate data
if strcmp(vary,'A') % vary land use
    inputData = LU;
elseif strcmp(vary,'C') % vary T record
    inputData = temp_anom;
elseif strcmp(vary,'F'); % vary fast box time constant
    inputData = [C1dt(:,1), C1dt(:,2)*-1]; % flux into fast box
elseif strcmp(vary,'G'); 
    %inputData = decon_resid;
    inputData = [C1dt(:,1), C1dt(:,2)*-1]; % flux into fast box
    %inputData = delCdt;
elseif strcmp(vary,'H');
    inputData = [fas(:,1),fas(:,2).*Aoc];
else
    inputData = NaN;
end

C1dt = [C1dt(:,1), C1dt(:,2)*-1];
C2dt = [C2dt(:,1), C2dt(:,2)*-1];

[ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff);
[RMSEunfilt,RMSEfilt,RMSEfiltShort] = calcErrors(ddtUnfilt,ddtFilt);
[outputArray] = fillArray(j,Q1,epsilon,gamma,inputData,atmcalc2,...
    obsCalcDiff,outputArray,ddtUnfilt,ddtFilt,RMSEunfilt,RMSEfiltShort,...
    RMSEfilt);

if strcmp(vary,'K')
    [landFluxArray] = fillLandFluxArray(landFluxArray,j,C1dt,C2dt,delCdt);
end

end

plotRunComparisons(outputArray, numCases,vary)

% TODO: the "if vary == K" is repetitive because plotBioxes also contains
% same call. started writing plotBioboxes to be used on any vary value,
% test if works for others?
if strcmp(vary,'K')
plotBioboxes(landFluxArray,numCases,vary);
end

%% saving the output array

outputArray

% function to save parameters in appropriate file name
%[outputArray] = saveParams(outputArray)



