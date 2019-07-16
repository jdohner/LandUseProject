% plotvsObs.m
%
% julia dohner
% oct 18, 2018
%
% code to replicate figures 5 & 7 from rafelski et al. 2009

function plotvsObs(run1,run2,outputArray, CO2a_obs,year);

% note: obs co2 record is smoothed

% top subplot: plot modeled and obs co2 record
legendInfo1 = [outputArray{run1+1,1}];
legendInfo2 = [outputArray{run2+1,1}];


Catm_modeled1 = outputArray{run1+1,6};
Catm_modeled2 = outputArray{run2+1,6};

figure('Name', 'CO2a, Obs-Modeled');
h1 = subplot(2,1,1);
plot(year,Catm_modeled1,year,Catm_modeled2)
hold on
plot(CO2a_obs(:,1),CO2a_obs(:,2),'linewidth',2,'color','k')
hold off
legend(legendInfo1,legendInfo2,'Observed','location','northwest')
grid
xlim([1900 2020])
ylabel('ppm','FontSize', 18)
set(h1,'FontSize',18)
title(h1,['Atmospheric CO_2 , ',legendInfo1, ' & ',legendInfo2, ' Run'],'FontSize',24)


% bottom subplot: obs - modeled CO2atm (difference between two above)
obsCalcDiff1 = outputArray{run1+1,7};
obsCalcDiff2 = outputArray{run2+1,7};

h2 = subplot(2,1,2);
plot(obsCalcDiff1(:,1),obsCalcDiff1(:,2),obsCalcDiff2(:,1),obsCalcDiff2(:,2))
grid
xlim([1900 2020])
ylim([-4 12])
ylabel('ppm','FontSize',18)
hline = refline([0 0]);
hline.Color = [0.7 0.7 0.7];
hline.LineStyle = '--';
hline.LineWidth = 2;
set(h2,'FontSize',18)
legend(legendInfo1,legendInfo2,'location','northwest')
title(h2,['Observed - Modeled CO_2 , ',legendInfo1, ' & ',legendInfo2, ' Run'],'FontSize',24)
    
end

% %code for plotting observed co2 and single decon residual below
% 
% figure
% 
% h1 = subplot(2,1,1)
% plot(CO2a_obs(:,1),CO2a_obs(:,2),'linewidth',2,'color','k')
% grid
% set(h1,'FontSize',18)
% xlim([1900 2020])
% 
% h2 = subplot(2,1,2)
% plot(decon_resid(:,1),decon_resid(:,2),'linewidth',2)
% grid
% set(h2,'FontSize',18)
% hline = refline([0 0]);
% hline.Color = [0.7 0.7 0.7];
% hline.LineStyle = '--';
% hline.LineWidth = 2;
% xlim([1900 2020])