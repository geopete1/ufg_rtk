close all,clear all
set_pna_colors
% DirPath='/Users/pna/Dropbox/SharedFolders/Shared_Matanzas_HurricaneIrma/Data_RTK/';
DirPath='/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/';
% Load Sept. 8 Survey Data (Pre-Irma)
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170908.mat'])
T_1=T;
clearvars -except DirPath T_1
% Load Sept. 13 Survey Data (Post-Irma)
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170913.mat'])
T_2=T;
clearvars -except DirPath T_1 T_2
% Load Sept. 26 Survey Data (Post-Maria)
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170926.mat'])
T_3=T;
clearvars -except DirPath T_1 T_2 T_3
% Load Sept. 8 Survey Data (Pre-Irma)
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20171019.mat'])
T_4=T;
clearvars -except DirPath T_1 T_2 T_3 T_4

%% Identify which transects we'll examine
keyTsect=[2:10:42]; % For North Section
XL=[80 200; 50 170; 50 170; 50 170; 50 170];

% keyTsect=[52:10:92]; % For Central Section
% XL=[20 140; 20 140; 20 140; 20 140; 40 160];

% % keyTsect=[102:10:132]; % For South Section
% XL=[80 200; 50 170; 50 170; 50 170; 50 170];
        
%% Plot the profiles for same scales
figure(1)
for i=1:5
    subplot(5,1,i)
    plot(T_1(keyTsect(i)).di,T_1(keyTsect(i)).zi,'b','linewidth',2),hold on
    plot(T_2(keyTsect(i)).di,T_2(keyTsect(i)).zi,'g','linewidth',2)
    plot(T_3(keyTsect(i)).di,T_3(keyTsect(i)).zi,'r','linewidth',2)
    plot(T_4(keyTsect(i)).di,T_4(keyTsect(i)).zi,'k','linewidth',2),grid on
    title(['Transect ' num2str(keyTsect(i))],'FontSize',14)
    if i==5
        xlabel('Cross Shore Position (m)')
    end
    legend('9/8/2017','9/13/2017','9/26/2017','10/19/2017')
    ylabel('Elev. (m)')
    set(gca,'XLim',[50 200],'YLim',[-29 -22],'FontSize',12)
    set(gca,'XLim',XL(i,:));
    drawnow,hold off,pause(0.5)
end

set(gcf,'units','inches','position',[2 15 8.5 11],...
    'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
print -r300 -dpng /Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/FigDumps/IrmaProfilesSameScale_North.png

%% Plot the profiles for different scales
% figure(2)
% for i=1:5
%     subplot(5,1,i)
%     plot(T_1(keyTsect(i)).di,T_1(keyTsect(i)).zi,'b','linewidth',2),hold on
%     plot(T_2(keyTsect(i)).di,T_2(keyTsect(i)).zi,'g','linewidth',2)
%     plot(T_3(keyTsect(i)).di,T_3(keyTsect(i)).zi,'r','linewidth',2)
%     plot(T_4(keyTsect(i)).di,T_4(keyTsect(i)).zi,'k','linewidth',2),grid on
%     title(['Transect ' num2str(keyTsect(i))],'FontSize',14)
%     if i==5
%         xlabel('Cross Shore Position (m)')
%         legend('9/8/2017','9/13/2017','9/26/2017','10/19/2017')
%     end
%     ylabel('Elev. (m)')
%     if i==1,set(gca,'XLim',[60 160],'YLim',[-29.5 -23],'FontSize',12),end
%     if i==2,set(gca,'XLim',[60 130],'YLim',[-29.5 -23],'FontSize',12),end
%     if i==3,set(gca,'XLim',[20 140],'YLim',[-29 -24],'FontSize',12),end
%     if i==4,set(gca,'XLim',[10 190],'YLim',[-29 -24.5],'FontSize',12),end
%     if i==5,set(gca,'XLim',[0 160],'YLim',[-29 -25.5],'FontSize',12),end
%     drawnow,hold off,pause(0.5)
% end
% 
% set(gcf,'units','inches','position',[2 15 8.5 11],...
%     'PaperSize',[8.5 11],'PaperPosition',[0 0 8.5 11])
% print -r300 -dpng /Users/pna/Desktop/IrmaProfilesDiffScales.png
