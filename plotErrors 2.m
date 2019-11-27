% plotErrors.m
%
% sept 7, 2019
%
% author: julia dohner
%
% plots histogram of MSE values

function plotErrors(LUensembleArray,nLU,scheme,year,numCases)

h1 = figure('Name','Ensemble MSE');
title('Ensemble MSE')
legendInfo = {};

hold on

for i = 1:nLU
    
    
    % amass MSE data
    errorArray = LUensembleArray{i+1,3};
    allVals_RMSE = zeros(1,numCases);
    % allVals_RMSE_GtCyr = zeros(1,numCases);
    for j = 1:numCases
        allVals_RMSE(:,j) = sqrt(errorArray{j+1,7});
        
    end
    allVals_RMSE_GtCyr = allVals_RMSE.*2.124; % convert to GtC
    
    subplot(nLU,1,i);
    % histogram(allVals_RMSE);
    histogram(allVals_RMSE_GtCyr);
    legendInfo{i} = LUensembleArray{i+1,1};
    %legend(legendInfo);
    
    legend(legendInfo{i},'location','northwest')
    xlabel('RMSE (GtC/yr)','FontSize', 18)
    ylabel('instances','FontSize',18)
    xlim([0 1.3]);
    ylim([0 150]);
    set(gca,'FontSize',18)
    grid 
    
    
end



hold off


end