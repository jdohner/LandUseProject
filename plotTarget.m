% plotTarget.m
%
% November 26, 2018
%
% Julia Dohner
%
% Script to plot the residual sink target, with GCP residual sink and land
% sink overlaid.

addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LandUseProject/necessary_data'));
addpath(genpath(...
    '/Users/juliadohner/Documents/MATLAB/LU_data_big'));
addpath(genpath(...
    '/Users/juliadohner/Dropbox/Science Communication/S3_2018/Presentation'));

d = 1/2.124; % PgC to ppm conversion factor

load decon_resid; % model-calculated residual

% all values in GtC/yr
GCPdata0 = csvread('Global_Carbon_Budget_2017v1.3.csv');
GCPdata = [GCPdata0(:,1), GCPdata0(:,2:7).*d];
GCPyear = GCPdata(:,1);
GCPff = GCPdata(:,2);
GCPlulcc = GCPdata(:,3);
GCPagr = GCPdata(:,4); % atmospheric growth
GCPocean = GCPdata(:,5); % ocean sink
GCPland = GCPdata(:,6); % land sink
GCPimbal = GCPdata(:,7); % budget imbalance

GCPresid = [GCPagr-GCPff+GCPocean-GCPlulcc];

[GCPlandFilt] = smooth(GCPland,11);
[GCPresidFilt] = smooth(GCPresid,11);

figure
plot(decon_resid(:,1),decon_resid(:,2))
hold on
plot(GCPyear,GCPresidFilt)
hold on
plot(GCPyear,-1*GCPlandFilt)
hold off
line([decon_resid(1,1),decon_resid(end,1)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010.5],'Ylim',[-2 1],'FontSize', 18)
xticks(1850:10:2010); yticks(-2:0.25:1)
title('Fitting Target: Residual Sink')
legend('Calculated in model','Calculated via GCP','GCP estimated land uptake','location','northwest')
xlabel('year','FontSize', 18)
ylabel('ppm / year','FontSize', 18)
grid

load temp_anom_i3;
CRUTEM4 = temp_anom;
CRUTEM4_filt = [CRUTEM4(:,1), smooth(CRUTEM4(:,2),11)];

load temp_anom_i1;
BrohanTemp = temp_anom;
BrohanTemp_filt = [BrohanTemp(:,1), smooth(BrohanTemp(:,2),11)];

figure
%plot(CRUTEM4_filt(:,1),CRUTEM4_filt(:,2))
%hold on
plot(BrohanTemp_filt(:,1),BrohanTemp_filt(:,2))
%hold off
line([CRUTEM4(1,1),CRUTEM4(end,1)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010.5],'Ylim',[-1 1],'FontSize', 18)
xticks(1850:10:2010); yticks(-1:0.25:1)
title('Fitting Target: Temperature Anomalies')
legend('Brohan et al. (2006)','location','northwest')
xlabel('year','FontSize', 18)
ylabel('deg C','FontSize', 18)
grid

%% plotting observations

% plot atmospheric co2 in ppm
% plot AGR in ppm 

ts = 12; % timesteps per year
d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
d1 = 1/d; % PgC to ppm conversion


ts = 12; % timesteps per year
start_year = 1850;
end_year = 2015.5; 
[dtdelpCO2a_obs,dpCO2a_obs,~,~,CO2a_obs] = getObservedCO2_2(ts,start_year,end_year);

figure
plot(CO2a_obs(:,1),CO2a_obs(:,2),'linewidth',2);
xlim([1950 2020]) 
xticks([1950:10:2020])
title('Atmospheric CO_2 Record')
set(gca, 'YGrid', 'on', 'XGrid', 'on')
%set(gca,'fontname','Helvetica')
set(gca,'fontsize',18)
ylabel('ppm')
xlabel('year')


AGRdata = csvread('AGR_GCPdata.csv',2); % in GtC/yr

figure('Name', 'GCP AGR');
plot(AGRdata(:,1),AGRdata(:,2)*d1,'linewidth',2); %,'color',[0.4940, 0.1840, 0.5560]);
xlim([1950 2020]) 
xticks([1950:10:2020])
set(gca, 'YGrid', 'on', 'XGrid', 'on')
%set(gca,'fontname','Helvetica')
set(gca,'fontsize',18)
ylabel('ppm/yr')
xlabel('year')
title('GCP CO_2 Atmospheric Growth Rate')

%% plot baseline modeled atmosphere


ts = 12; % timesteps per year
d = 2.134; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)
d1 = 1/d; % PgC to ppm conversion

load baseline1900_CO2a;
load baseline1900_CO2a_year;
baseline1900_CO2a = [year,atmcalc2];

load deltaci0_1900_CO2a;
deltaci0_1900_CO2a = [year, atmcalc2];

figure('Name','modeled and obs co2a')
plot(baseline1900_CO2a(:,1),baseline1900_CO2a(:,2),'linewidth',2); %,'color',[0.4940, 0.1840, 0.5560]);
xlim([1950 2020]) 
xticks([1950:10:2020])
set(gca, 'YGrid', 'on', 'XGrid', 'on')
%set(gca,'fontname','Helvetica')
set(gca,'fontsize',18)
ylabel('ppm')
xlabel('year')
title('Modeled Atmospheric CO_2')

% plot modeled AGR
for i = ((ts/2)+1):(length(baseline1900_CO2a)-(ts/2))
      AGRbaseline_1900_2010(i,1) = baseline1900_CO2a(i,1);
    AGRbaseline_1900_2010(i,2) = baseline1900_CO2a(i+(ts/2),2) - baseline1900_CO2a(i-(ts/2),2);
end

for i = ((ts/2)+1):(length(deltaci0_1900_CO2a)-(ts/2))
      AGRdeltaCi_1900_2010(i,1) = deltaci0_1900_CO2a(i,1);
    AGRdeltaCi_1900_2010(i,2) = deltaci0_1900_CO2a(i+(ts/2),2) - deltaci0_1900_CO2a(i-(ts/2),2);
end


figure('Name','modeled & obs AGR')
plot(AGRdata(:,1),AGRdata(:,2)*d1,'linewidth',2); %,'color',[0.4940, 0.1840, 0.5560]);
hold on 
plot(AGRbaseline_1900_2010(:,1),AGRbaseline_1900_2010(:,2),'linewidth',2); %,'color',[0.4940, 0.1840, 0.5560]);
hold on
plot(AGRdeltaCi_1900_2010(:,1),AGRdeltaCi_1900_2010(:,2),'linewidth',2);
hold off
xlim([1950 2020]) 
xticks([1950:10:2020])
set(gca, 'YGrid', 'on', 'XGrid', 'on')
%set(gca,'fontname','Helvetica')
set(gca,'fontsize',18)
ylabel('ppm/yr')
xlabel('year')
title('Modeled Atmospheric CO_2 Growth Rate')
legend('Observed','Modeled (baseline)','Modeled (\Delta C_i = 0)','location','northwest')

%% plot errors as PDFs

load zeroBio_i_1900_restVarsi_outputArray;

error_baseline = outputArray{2,7};
errorFlux_baseline = outputArray{2,8};
errorFluxFilt_baseline = outputArray{2,9};

error_deltaCi0 = outputArray{4,7};
errorFlux_deltaCi0 = outputArray{4,8};
errorFluxFilt_deltaCi0 = outputArray{4,9};

figure('name','Errors PDF');
subplot(2,1,1)
histogram(error_baseline(:,2)*d1,'Normalization','pdf');
set(gca,'FontSize',16);
title('Baseline Run Error PDF');
xlabel('ppm/yr','FontSize',16);
%ylabel('probability', 'FontSize',16);
ylim([0 0.8])
xlim([-3 3])
subplot(2,1,2)
histogram(error_deltaCi0(:,2)*d1,'Normalization','pdf');
set(gca,'FontSize',16);
title('\Delta C_i = 0 Run Error PDF');
xlabel('ppm/yr','FontSize',16);
%ylabel('probability', 'FontSize',16);
ylim([0 0.8])
xlim([-3 3])

% flux error PDFs

figure('name','Flux Errors PDF');
subplot(2,1,1)
histogram(errorFlux_baseline(:,2)*d1,'Normalization','pdf');
set(gca,'FontSize',16);
title('Baseline Run Error Flux PDF');
xlabel('ppm','FontSize',16);
%ylabel('probability', 'FontSize',16);
ylim([0 1.25])
xlim([-2 2])
subplot(2,1,2)
histogram(errorFlux_deltaCi0(:,2)*d1,'Normalization','pdf');
set(gca,'FontSize',16);
title('\Delta C_i = 0 Run Error Flux PDF');
xlabel('ppm/yr','FontSize',16);
%ylabel('probability', 'FontSize',16);
ylim([0 1.25])
xlim([-2 2])