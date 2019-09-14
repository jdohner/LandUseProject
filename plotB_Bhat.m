% plotB_Bhat.m
%
% sept 10, 2019
%
% author: julia dohner
%
% script to plot comparison of typical (close to mean of RMSE values) run
% for modeled Bhat versus target B (B denoting land uptake of carbon)

function plotB_Bhat(LUensembleArray,numCases,scheme,nLU,year)

figure('NumberTitle','off','Name','B & Bhat comparisons');
legendInfo = {};
%colorVec = jet(numCases);
colorVec = [0.6350 0.0780 0.1840; 0.8500 0.3250 0.0980;...
            0 0.4470 0.7410; 0.3010 0.7450 0.9330;...
            0.9290 0.6940 0.1250; 0.4660 0.6740 0.1880];
hold all

for i = 1:nLU
    
    j = (i*2-1);
    k = (i*2);

if numCases == 1000 && strcmp(scheme,'aa')
    
    % amass MSE data
    if i == 1 % H&N
        member = 12;
    elseif i == 2 % BLUE
        member = 54;
    elseif i == 3 % constant
        member = 45;
    end
      
elseif numCases == 1000 && strcmp(scheme,'bb')
    
    % amass MSE data
    if i == 1 % H&N
        member = 53;
    elseif i == 2 % BLUE
        member = 75;
    elseif i == 3 % constant
        member = 75;
    end
    
end

    typicalBhat = LUensembleArray{i+1,2}{member,4};
    typicalB = LUensembleArray{i+1,2}{member,5};
       
    %subplot(nLU,1,i);
    hold on
    plot(year,typicalBhat,'linewidth',2,'Color',colorVec(j,:))
    plot(year,typicalB(:,2),'--','linewidth',2,'Color',colorVec(k,:))
    legendInfo{j} = strcat(LUensembleArray{i+1,1},'-Bhat (modeled)'); % fix legend info here - need two entries
    legendInfo{k}=strcat(LUensembleArray{i+1,1},'-B');
    %legend(legendInfo);
    
    legend(legendInfo,'location','northwest')
    xlabel('RMSE (ppm)','FontSize', 18)
    ylabel('instances','FontSize',18)
    
    
    xlim([1900 2015])
    
        
%     xlim([0 0.5]);
%     ylim([0 150]);
    set(gca,'FontSize',18)
    grid 
    
end

hold off
end

