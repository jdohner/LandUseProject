% plotRunComparisons.m
%
% julia dohner
% july 24, 2018

function plotRunComparisons(outputArray, numCases,vary);

d = 2.31; % ppm to PgC conversion factor (formerly 1/2.31 opp direction)

%% plotting varied input datasets
if ~isnan(outputArray{2,5}) 
    % varied input datasets plot - ONLY for varied LU, T record,
    % timeconst, filter/no filter decon resid, ocean uptake
    figure('NumberTitle', 'off', 'Name', 'Input Data');
    legendInfo = {};
    colorVec = lines(numCases);
    subplot(3,1,1)
    hold on

    for i = 1:numCases
        inputData = outputArray{i+1,5};
        legendInfo{i} = [outputArray{i+1,1}];

        plot(inputData(:,1),(inputData(:,2).*d),'Color',colorVec(i,:))
    end
    hold off

    legend(legendInfo,'location','northwest')
    xlabel('Year','FontSize', 18)
    set(gca,'FontSize',18)
    
    set(gca,'FontSize',18)
    xlim([1840 2016])
    if strcmp(vary,'G') % for decon filt/nofilt
        ylim([-5 5])
        yticks([-5:5])
        ylabel('PgC/yr','FontSize', 18)
%         ylim([-1 2])
%         yticks([-1:2])
%         ylabel('PgC/yr','FontSize', 18)
    elseif strcmp(vary,'C') % temp records
        ylim([-2 2])
        yticks([-2:2])
        ylabel('degrees C','FontSize', 18)
    else
        ylim([-1 2])
        yticks([-1:2])
        ylabel('PgC/yr','FontSize', 18)
    end
    grid



for i = 1:numCases
    legendInfo{i} = [outputArray{i+1,1}];
    
    ddtUnfilt = outputArray{i+1,8};
    hold on
    h1 = subplot(3,1,2);
    plot(ddtUnfilt(:,1),ddtUnfilt(:,2),'Color',colorVec(i,:))
    hold off
    
    ddtFilt = outputArray{i+1,9};
    hold on
    h2 = subplot(3,1,3);
    plot(ddtFilt(:,1),ddtFilt(:,2),'Color',colorVec(i,:))
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
ylim(h2,[-4 4])
yticks(h2,[-4:4])
grid(h2)


else
    
% residual fluxes plot

colorVec = lines(numCases);
figure('NumberTitle', 'off', 'Name', 'Obs-Model Flux Discrepancies');

for i = 1:numCases
    legendInfo{i} = [outputArray{i+1,1}];
    
    ddtUnfilt = outputArray{i+1,8};
    hold on
    h1 = subplot(2,1,1);
    plot(ddtUnfilt(:,1),ddtUnfilt(:,2),'Color',colorVec(i,:))
    %line([ddtUnfilt(1),ddtUnfilt(end,1)],[0,0],'linestyle',':');
    hold off
    
    ddtFilt = outputArray{i+1,9};
    hold on
    h2 = subplot(2,1,2);
    plot(ddtFilt(:,1),ddtFilt(:,2),'Color',colorVec(i,:))
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
ylim(h2,[-4 4])
yticks(h2,[-4:4])
grid(h2)


%% 3-panel plot
% will need to find a way to plot temp-dep runs here - re-run forward
% driver with tempDep = 0?


end

%% plotting land uptakes

       
figure('Name','Land Boxes Uptake')

for i = 1:numCases

subplot(numCases,1,i) %baseline run

C1dt = outputArray{i+1,13};
C2dt = outputArray{i+1,14};
delCdt = outputArray{i+1,15};
hold on
plot(C1dt(:,1),C1dt(:,2)*d,C2dt(:,1),C2dt(:,2)*d)
plot(delCdt(:,1), delCdt(:,2)*d,'-.')
hold off    
line([C1dt(1),C1dt(end,1)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010.5],'Ylim',[-4 4],'FontSize', 18)
xticks(1850:10:2010); yticks(-4:2:4)
title(outputArray{i+1,1})
legend('Fast box','Slow box','Total','location','northwest')
xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid

end

%% plotting changing box sizes

figure('Name','Land Box Sizes')

for i = 1:numCases

subplot(numCases,1,i) %baseline run

delC1 = outputArray{i+1,16};
delC2 = outputArray{i+1,17};
hold on
plot(delC1(:,1),delC1(:,2)*d,delC2(:,1),delC2(:,2)*d)
hold off    
line([delC1(1),delC1(end,1)],[0,0],'linestyle',':');
set(gca,'Xlim',[1850 2010.5],'Ylim',[-12 18],'FontSize', 18)
xticks(1850:10:2010); yticks(-12:6:18)
title(outputArray{i+1,1})
legend('Fast box size change','Slow box size change','location','northwest')
xlabel('year','FontSize', 18)
ylabel('PgC / year','FontSize', 18)
grid

end
    
    


end