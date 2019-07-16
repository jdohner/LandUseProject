% plotEnsembles.m
%
% julia dohner
% july 24, 2018

function plotEnsembles(outputArray, numCases,vary);

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


