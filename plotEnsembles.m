% plotEnsembles.m
%
% julia dohner
% july 24, 2018

function plotEnsembles(outputArray, numCases,vary,year)


%% calculating max and min arrays to create shaded regions

% compile all CO2a and AGR values
allVals_CO2a = zeros(length(year),numCases+1);
allVals_CO2a(:,1) = year;
allVals_dtdelpCO2a = allVals_CO2a;

for i = 2:numCases+1
    allVals_CO2a(:,i) = outputArray{i,6};
    
    obsCalcDiff = outputArray{i,7};
    allVals_dtdelpCO2a(:,i) = obsCalcDiff(:,2);
end

% calculate all max, min and mean values
minCO2a = zeros(length(year),2);
minCO2a(:,1) = year;
maxCO2a = minCO2a;
meanCO2a = minCO2a;
mindtdelpCO2a = minCO2a;
maxdtdelpCO2a = minCO2a;
meandtdelpCO2a = minCO2a;

for i = 1:length(allVals_CO2a)
    minCO2a(i,2) = min(allVals_CO2a(i,2:end));
    maxCO2a(i,2) = max(allVals_CO2a(i,2:end));
    meanCO2a(i,2) = mean(allVals_CO2a(i,2:end));
    mindtdelpCO2a(i,2) = min(allVals_dtdelpCO2a(i,2:end));
    maxdtdelpCO2a(i,2) = max(allVals_dtdelpCO2a(i,2:end));
    meandtdelpCO2a(i,2) = mean(allVals_dtdelpCO2a(i,2:end));
end

%% shadederrorbars plots

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/MATLAB_toolkits'));

%shadedErrorBar(year,m


%% handmade translucent plots
% plotting shaded area of max and min modeled CO2a values
figure('Name', 'Modeled CO2a Spread');
x = year';
plot(minCO2a(:,1),minCO2a(:,2),'color',[0.71, 0.84, 0.87]);
hold on;
plot(maxCO2a(:,1),maxCO2a(:,2),'color',[0.71, 0.84, 0.87]);
x2 = [year',fliplr(year')];
inBetween = [minCO2a(:,2)',fliplr(maxCO2a(:,2)')];
fill(x2,inBetween,[0.71, 0.84, 0.87],'LineStyle','none');
hold on;
plot(meanCO2a(:,1),meanCO2a(:,2),'color',[0.32, 0.35, 0.35]);

% plotting shaded area of max and min modeled dtdelpCO2a values
figure('Name', 'Modeled AGR Spread');
x = year';
plot(mindtdelpCO2a(:,1),mindtdelpCO2a(:,2),'color',[0.71, 0.84, 0.87]);
hold on;
plot(maxdtdelpCO2a(:,1),maxdtdelpCO2a(:,2),'color',[0.71, 0.84, 0.87]);
x2 = [year',fliplr(year')];
inBetween = [mindtdelpCO2a(:,2)',fliplr(maxdtdelpCO2a(:,2)')];
fill(x2,inBetween,[0.71, 0.84, 0.87],'LineStyle','none');
hold on;
plot(meandtdelpCO2a(:,1),meandtdelpCO2a(:,2),'color',[0.32, 0.35, 0.35]);

d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
d1 = 1/d; % PgC to ppm


% residual fluxes plot
colorVec = lines(numCases);
figure('Name', 'Obs-Model Flux Discrepancies');

for i = 1:numCases
    legendInfo{i} = [outputArray{i+1,1}];
    
    ddtUnfilt = outputArray{i+1,8};
    hold on
    h1 = subplot(2,1,1);
    plot(ddtUnfilt(:,1),ddtUnfilt(:,2),'Color',colorVec(i,:),'linewidth',2)
    %line([ddtUnfilt(1),ddtUnfilt(end,1)],[0,0],'linestyle',':');
    hold off
    
    ddtFilt = outputArray{i+1,9};
    hold on
    h2 = subplot(2,1,2);
    plot(ddtFilt(:,1),ddtFilt(:,2),'Color',colorVec(i,:),'linewidth',2)
    %line([ddtFilt(1),ddtFilt(end,1)],[0,0],'linestyle',':');
    hold off
    %legendInfo{i} = [outputArray{i+1,1}];
end
hold off

% want to set plot features indivudally for subplots
title(h1, 'Obs-Model Flux Discrepancy (unsmoothed)')
legend(h1,legendInfo,'location','northwest')
xlabel(h1,'Year','FontSize', 18)
set(h1,'FontSize',18)
ylabel(h1,'PgC/yr','FontSize', 18)
set(h1,'FontSize',18)
xlim(h1,[1840 2016])
ylim(h1,[-4 4])
yticks(h1,[-4:4])
grid(h1)

title(h2,'Obs-Model Flux Discrepancy (smoothed)')
legend(h2,legendInfo,'location','northwest')
xlabel(h2,'Year','FontSize', 18)
set(h2,'FontSize',18)
ylabel(h2,'PgC/yr','FontSize', 18)
set(h2,'FontSize',18)
xlim(h2,[1840 2016])
ylim(h2,[-3 2])
yticks(h2,[-3:2])
grid(h2)


