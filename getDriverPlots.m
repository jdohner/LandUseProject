% getDriverPlots.m
%
% june 29, 2018
% julia dohner
%
% script to output plots for forward driver
%
% NOT CURRENTLY BEING CALLED 8/30/18

function getDriverPlots(varSST,CO2a_obs,year,atmcalc2,year3,temp_anom,...
    sstAnom,decon_filt,delC10,yhat2,LU,ff,fas,Aoc,obsCalcDiff)


if varSST == 1
    
    figure('Name','Modeled vs. Observed CO2')
    subplot(4,1,1)
    plot(CO2a_obs(:,1), CO2a_obs(:,2),year,atmcalc2);
    xlabel('year')
    ylabel('ppm CO2')
    title('Atmospheric CO2 history')
    legend('Observations','Temperature-dependent model','location','northwest');
    grid
    subplot(4,1,2)
    plot(obsCalcDiff(:,1),obsCalcDiff(:,2));
    line([year3(1),year3(end)],[0,0],'linestyle','--');
    grid
    legend('Observed - modeled CO2','location','northeast')
    xlabel('year')
    ylabel('ppm CO2')
    title('Observed CO2 Deviation from Modeled CO2')
    subplot(4,1,3)
    plot(temp_anom(:,1),temp_anom(:,2))
    line([year3(1),year3(end)],[0,0],'linestyle','--');
    grid
    legend('Temperature anomaly','location','northeast')
    xlabel('year')
    ylabel('deg C')
    title('Temperature anomaly')
    subplot(4,1,4)
    plot(sstAnom(:,1),sstAnom(:,2))
    line([year3(1),year3(end)],[0,0],'linestyle','--');
    grid
    legend('SST anomaly','location','northeast')
    xlabel('year')
    ylabel('deg C')
    title('SST anomaly')
    
else
    

    figure('Name','Modeled vs. Observed CO2')
    subplot(3,1,1)
    plot(CO2a_obs(:,1), CO2a_obs(:,2),year3,atmcalc2);
    xlabel('year')
    ylabel('ppm CO2')
    title('Atmospheric CO2 history')
    legend('Observations','Temperature-dependent model','location','northwest');
    grid
    subplot(3,1,2)
    plot(obsCalcDiff(:,1),obsCalcDiff(:,2));
    line([year3(1),year3(end)],[0,0],'linestyle','--');
    grid
    legend('Observed - modeled CO2','location','northeast')
    xlabel('year')
    ylabel('ppm CO2')
    title('Observed CO2 Deviation from Modeled CO2')
    subplot(3,1,3)
    plot(temp_anom(:,1),temp_anom(:,2))
    grid
    legend('Temperature anomaly','location','northeast')
    xlabel('year')
    ylabel('deg C')
    title('Temperature anomaly')

end
saveas(gcf,'CO2recordsFig.fig') 

figure('Name','Land Uptake')
plot(decon_filt(:,1),decon_filt(:,2),delC10(:,1),yhat2,LU(:,1), LU(:,2),'-.')
line([year3(1),year3(end)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010]) 
title('Residual Land Flux')
legend('Residual land flux','Residual land flux (model)','Land use emissions','location','northwest')
xlabel('year')
ylabel('ppm / year')
grid

saveas(gcf,'landFluxFig.fig')
