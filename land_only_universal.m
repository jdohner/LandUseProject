% land_only_universal.m
%
% julia dohner
% october 8, 2018
%
% code for only the land component extracted, fit to T record with set Q10
% to investigate the role of the changing box size term
% 
% fitting already done, just feeding land model the fitted parameters
%
% code updated so can take in any looped run comparisons, not just
% zeroing terms in land box

% suggested inputs:
% Q1 = 0.8890
% epsilon = 0.1999

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

vary = 'I';

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


outputArray = cell(numCases+1,17);
outputArray(1,:) = {'Run Version','Q10','epsilon','gamma','input data',...
    'atmcalc2','obsCalcDiff','ddtUnfilt','ddtFilt','RMSEfilt 1900-2014'...
    'RMSEfilt 1958-2014','RMSEunfilt 1958-2014','C1dt','C2dt','delCdt',...
    'delC1','delC2'};

Tconst = 18.2; % surface temperature, deg C, from Joos 1996
ts = 12; % timesteps per year
dt = 1/ts;
start_year = 1850;
end_year = 2015.5; 
year = (start_year:(1/ts):end_year)';
Aoc = 3.62E14; % surface area of ocean, m^2, from Joos 1996
co2_preind = 600/2.12; % around 283 ppm (preindustrial)


addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));

[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);

Q1 = 5.4230;%2.2256;
Q2 = 1;
epsilon = 0.3855; %0.3049;%0.3349;



% Q2 = 1;
% ts = 12;
% dt = 1/ts;
% start_year = 1850;
% end_year = 2015.5;
% year = (start_year:dt:end_year)';
% load dpCO2a_obs.mat dpCO2a_obs;
% gamma = 0; % no N fertilization
% photResp_i = 1; % looping temp-dep photosynthesis or respiration
% timeConst_i = 1; % looping scaling time constant in fast land box
% numCases = 4; 
% rowLabels = {'Baseline','Epsilon = 0','\DeltaC_i = 0','Epsilon & \DeltaC_i = 0'};
% Tdata_i = 1; % 1 is match LR, 2 if want more legit record
% [temp_anom] = tempRecord3(Tdata_i,start_year,end_year,dt);
% vary = 'K';
% landFluxArray = cell(numCases,4);
% landFluxArray(1,:) = {'Run Version','C1dt','C2dt','delCdt'};


for j = 1:numCases
    
% get the indices for variables being looped/held fixed    
[LU_i,opt_i,Tdata_i,tempDep_i,varSST_i,timeConst_i,filt_i,...
    fert_i,oceanUp_i,photResp_i,zeroBio_i,rowLabels] = getLoopingVar(vary,j);

save('runInfo','start_year','end_year','ts','year','fert_i',...
    'oceanUp_i','tempDep_i','varSST_i','filt_i',...
    'rowLabels','opt_i','photResp_i','timeConst_i','zeroBio_i');

if fert_i == 1   
    gamma = 0;
elseif fert_i == 2 % nitrogen fertilization
    eps = 0;
    gamma = 1; % set this!
end

if tempDep_i == 2
    Q1 = 1;
end


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


%%

[C1dt,C2dt,delCdt,delC1,delC2] = bioboxtwo(epsilon,Q1,Q2,ts,year,...
    dpCO2a_obs,temp_anom,gamma,photResp_i,timeConst_i,zeroBio_i);

delCdt(:,2) = -delCdt(:,2); % change sign of land uptake

if filt_i == 1 % 10-yr filter applied
    [delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);
    yhat2 = delC10(:,2);
elseif filt_i == 2
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

% ^ 10-year filter not applied after calculating land uptake

[ddtUnfilt,ddtFilt] = calcDerivs(obsCalcDiff);
[RMSEunfilt,RMSEfilt,RMSEfiltShort] = calcErrors(ddtUnfilt,ddtFilt);
[delC10] = l_boxcar(delCdt,10,12,1,length(delCdt),1,2);

 
 
 
[outputArray] = fillArray(j,Q1,epsilon,gamma,inputData,...
                                atmcalc2,obsCalcDiff,outputArray,...
                                ddtUnfilt,ddtFilt,RMSEunfilt,...
                                RMSEfiltShort,RMSEfilt,C1dt,C2dt,...
                                delCdt,delC1,delC2);

%[landFluxArray] = fillLandFluxArray(landFluxArray,j,C1dt,C2dt,delCdt);

end

plotRunComparisons(outputArray, numCases,vary)

%plotBioboxes(landFluxArray,numCases,vary);

outputArray