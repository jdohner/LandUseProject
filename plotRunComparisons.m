% plotRunComparisons.m
%
% julia dohner
% july 24, 2018

function plotRunComparisons(outputArray, numCases);

%% LU datasets plot
figure
legendInfo = {};
colorVec = lines(13);
hold on

for i = 1:numCases
    LU = outputArray{i+1,2};
    legendInfo{i} = [outputArray{i+1,1}];
    plot(LU(:,1),LU(:,2),'Color',colorVec(i,:))
end
hold off

legend(legendInfo,'location','northwest')
xlabel('Year','FontSize', 18)
set(gca,'FontSize',18)
ylabel('PgC/yr','FontSize', 18)
set(gca,'FontSize',18)
xlim([1840 2016])
ylim([0 2])
yticks([0:6])
grid

%% residual fluxes plot 

%legendInfo = {};
colorVec = lines(13);
figure

for i = 1:numCases
    ddtUnfilt = outputArray{i+1,7};
    hold on
    h1 = subplot(2,1,1);
    plot(ddtUnfilt(:,1),ddtUnfilt(:,2),'Color',colorVec(i,:))
    hold off
    
    ddtFilt = outputArray{i+1,8};
    hold on
    h2 = subplot(2,1,2);
    plot(ddtFilt(:,1),ddtFilt(:,2),'Color',colorVec(i,:))
    hold off
    %legendInfo{i} = [outputArray{i+1,1}];
end
hold off

% want to set plot features indivudally for subplots
title(h1, 'Unfiltered Residual Fluxes')
legend(h1,legendInfo,'location','northwest')
xlabel(h1,'Year','FontSize', 18)
set(h1,'FontSize',18)
ylabel(h1,'PgC/yr','FontSize', 18)
set(h1,'FontSize',18)
xlim(h1,[1840 2016])
ylim(h1,[-4 4])
yticks(h1,[-4:4])
grid(h1)

title(h2,'Filtered Residal Fluxes')
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