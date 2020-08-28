% plotLU.m
%
% August 29, 2019
% author: julia dohner

load inputData.mat
colorVec = hsv(11);

d = 1/2.124; % gigaton to ppm conversion factor

figure
hold on
plot(Houghton2017(:,1),Houghton2017(:,2),'Color',[0.9290, 0.6940, 0.1250],'linewidth',4)
plot(Hansis2015_I(:,1),Hansis2015_I(:,2),'Color',[0, 0.4470, 0.7410],'linewidth',4)
% plot(ConstantLU(:,1),ConstantLU(:,2).*d,'Color',colorVec(3,:),'linewidth',4)
% plot(GCP2017(:,1),GCP2017(:,2).*d,'Color',colorVec(4,:),'linewidth',4)
% plot(CABLE2016(:,1),CABLE2016(:,2).*d,'Color',colorVec(5,:),'linewidth',4)
% plot(CABLE2016high(:,1),CABLE2016high(:,2).*d,'Color',colorVec(6,:),'linewidth',4)
% plot(LPXBern2016_HYDE(:,1),LPXBern2016_HYDE(:,2).*d,'Color',colorVec(7,:),'linewidth',4)
% plot(LPXBern2016_LUH(:,1),LPXBern2016_LUH(:,2).*d,'Color',colorVec(8,:),'linewidth',4)
% plot(ORCHIDEEMICT2016(:,1),ORCHIDEEMICT2016(:,2).*d,'Color',colorVec(9,:),'linewidth',4)
% plot(OCN2016(:,1),OCN2016(:,2).*d,'Color',colorVec(10,:),'linewidth',4)
hold off


% plot(Houghton2017(:,1),Houghton2017(:,2).*d,'Color',colorVec(1),...
%     Hansis2015_I(:,1),Hansis2015_I(:,2).*d,'Color',colorVec(2),...
%     ConstantLU(:,1),ConstantLU(:,2).*d,'Color',colorVec(3),...
%     GCP2017(:,1),GCP2017(:,2).*d,'Color',colorVec(4),...
%     CABLE2016(:,1),CABLE2016(:,2).*d,'Color',colorVec(5),...
%     CABLE2016high(:,1),CABLE2016high(:,2).*d,'Color',colorVec(6),...
%     LPXBern2016_HYDE(:,1),LPXBern2016_HYDE(:,2).*d,'Color',colorVec(7),...
%     LPXBern2016_LUH(:,1),LPXBern2016_LUH(:,2).*d,'Color',colorVec(8),...
%     ORCHIDEEMICT2016(:,1),ORCHIDEEMICT2016(:,2).*d,'Color',colorVec(9),...
%     OCN2016(:,1),OCN2016(:,2).*d,'Color',colorVec(10),...
%     'linewidth',4)

grid

legend('H&N2017','BLUE','constant','GCP','CABLE','CABLE high','LPX-Bern HYDE',...
    'LPX-Bern LUH','ORCHIDEE-MICT','OC-N','location','northwest')


xlabel('Year','FontSize', 18)
ylabel('ppm/year','FontSize',18)
set(gca,'FontSize',18)