% plotTarget.m
%
% November 26, 2018
%
% Julia Dohner
%
% Script to plot the residual sink target, with GCP residual sink and land
% sink overlaid.

d = 1/2.31; % PgC to ppm conversion factor

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