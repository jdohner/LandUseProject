% plotBioboxes.m
%
% julia dohner
% august 29, 2018
%
% plots fluxes in land boxes


function plotBioboxes(landFluxArray,numCases,vary)

% C1dt: flux into fast box
% C2dt: flux into slow box
% delCdt: total flux into land


if strcmp(vary,'K')
    
       
    figure('Name','Land Boxes Uptake')
    
    for i = 1:numCases
        
    subplot(numCases,1,i) %baseline run
    
    C1dt = landFluxArray{i+1,2};
    C2dt = landFluxArray{i+1,3};
    delCdt = landFluxArray{i+1,4};
    plot(C1dt(:,1),C1dt(:,2),C2dt(:,1),C2dt(:,2),delCdt(:,1), delCdt(:,2))
    line([C1dt(1),C1dt(end)],[0,0],'linestyle',':');
    set(gca,'Xlim',[1850 2010]) 
    title('Land Boxes Flux')
    legend('Flux into fast box','Flux into slow box','Total land flux','location','northwest')
    xlabel('year')
    ylabel('ppm / year')
    grid
    
    end

else
    
    figure('Name','Land Boxes Uptake')
    plot(C1dt(:,1),C1dt(:,2),C2dt(:,1),C2dt(:,2),delCdt(:,1), delCdt(:,2))
    line([C1dt(1),C1dt(end)],[0,0],'linestyle',':');
    set(gca,'Xlim',[1850 2010]) 
    title('Land Boxes Flux')
    legend('Flux into fast box','Flux into slow box','Total land flux','location','northwest')
    xlabel('year')
    ylabel('ppm / year')
    grid

    
end



end

