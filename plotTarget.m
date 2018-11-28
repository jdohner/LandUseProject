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
GCPdata = [GCPdata(:,1), GCPdata(:,2:7).*d];
GCPyear = GCPdata(:,1);
GCPff = GCPdata(:,2);
GCPlulcc = GCPdata(:,3);
GCPagr = GCPdata(:,4); % atmospheric growth
GCPocean = GCPdata(:,5); % ocean sink
GCPland = GCPdata(:,6); % land sink
GCPimbal = GCPdata(:,7); % budget imbalance

GCPresid = [GCPyear, GCPagr-GCPff+GCPocean-GCPlulcc];

figure
plot(decon_resid(:,1),decon_resid(:,2))
hold on
plot(GCPresid(:,1),GCPresid(:,2))
hold on
plot(GCPyear,GCPland)
hold off
line([decon_resid(1,1),decon_resid(end,1)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010.5],'Ylim',[-1 1],'FontSize', 18)
xticks(1850:10:2010); yticks(-1:0.25:1)
title('Fitting Target: Residual Sink')
%legend('Calculated in model','Calculated via GCP','GCP estimated land uptake','location','northwest')
xlabel('year','FontSize', 18)
ylabel('ppm / year','FontSize', 18)
grid