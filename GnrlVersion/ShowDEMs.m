close all,clear all
%% Draw DEM over 1999 CIR air photo
ImgDir='/Users/pna/Dropbox/Data/Data09_Imagery/Matanzas_FL/';
% DirPath='/Users/pna/Dropbox/SharedFolders/Shared_Matanzas_HurricaneIrma/Data_RTK/';
DirPath='/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/';
section='north'; % options=['whole','north','central','south'];
if strcmp(section,'whole')
    keyTsect=[16 68 81 106 125]; XL=[4.775e5 4.783e5]; YL=[32.859e5 32.877e5];
elseif strcmp(section,'north')
    keyTsect=[2:10:42]; XL=[4.776e5 4.779e5]; YL=[32.872e5 32.877e5];
elseif strcmp(section,'central')
    keyTsect=[52:10:92]; XL=[4.778e5 4.781e5]; YL=[32.867e5 32.872e5];
elseif strcmp(section,'south')
    keyTsect=[102:10:142]; XL=[4.775e5 4.783e5]; YL=[32.859e5 32.877e5];
end
%% Make the figure for Pre- and Post-Irma DEMs
figure(1)
set(gcf,'units','inches','position',[2 15 11 8.5],...
    'PaperSize',[11 8.5],'PaperPosition',[0 0 11 8.5])
subplot(1,2,1)
mapshow([ImgDir '2008_01_28_HR.tif']),hold on
% mapshow([ImgDir '1999_1_26_Mtnzs.tif']),hold on
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170908.mat'])
pcolor(Xg_n,Yg_n,Zg_n),pcolor(Xg_s,Yg_s,Zg_s)
shading interp,colormap jet
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    plot(T(keyTsect(i)).xi(indsReal),T(keyTsect(i)).yi(indsReal),'b','linewidth',1.5)
    clear indsReal
end
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    if sum(indsReal)>0
        text(T(keyTsect(i)).xi(indsReal(end)),T(keyTsect(i)).yi(indsReal(end)),['T ' num2str(keyTsect(i))],'color','w')
    end
    clear indsReal
end
title('Pre-Irma, Sept. 8','FontSize',14)
set(gca,'YLim',YL,'XLim',XL,'Clim',[-30 -21],'FontSize',8)
xlabel('m East (UTM Zone 17R)'),ylabel('m North (UTM Zone 17R)')

subplot(1,2,2)
mapshow([ImgDir '2008_01_28_HR.tif']),hold on
% mapshow([ImgDir '1999_1_26_Mtnzs.tif']),hold on
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170913.mat'])
pcolor(Xg_n,Yg_n,Zg_n),pcolor(Xg_s,Yg_s,Zg_s)
shading interp,colormap jet
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    plot(T(keyTsect(i)).xi(indsReal),T(keyTsect(i)).yi(indsReal),'g','linewidth',1.5)
    clear indsReal
end
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    if sum(indsReal)>0
        text(T(keyTsect(i)).xi(indsReal(end)),T(keyTsect(i)).yi(indsReal(end)),['T ' num2str(keyTsect(i))],'color','w')
    end
    clear indsReal
end
title('Post-Irma, Sept. 13','FontSize',14)
set(gca,'YLim',YL,'XLim',XL,'Clim',[-30 -21],'FontSize',8)
xlabel('m East (UTM Zone 17R)'),ylabel('m North (UTM Zone 17R)')
%% Print the Pre-and Post-Irma DEMs figure
print('-r300','-dpng',['/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/FigDumps/DEMs_1_PrePostIrma_' section '.png'])

%% Make the figure for Recovery survey DEMs (Sept. 26 and Oct. 19)
figure(2)
set(gcf,'units','inches','position',[2 15 11 8.5],...
    'PaperSize',[11 8.5],'PaperPosition',[0 0 11 8.5])
subplot(1,2,1)
mapshow([ImgDir '2008_01_28_HR.tif']),hold on
% mapshow([ImgDir '1999_1_26_Mtnzs.tif']),hold on
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20170926.mat'])
pcolor(Xg_n,Yg_n,Zg_n),pcolor(Xg_s,Yg_s,Zg_s)
shading interp,colormap jet
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    plot(T(keyTsect(i)).xi(indsReal),T(keyTsect(i)).yi(indsReal),'r','linewidth',1.5)
    clear indsReal
end
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    if sum(indsReal)>0
        text(T(keyTsect(i)).xi(indsReal(end)),T(keyTsect(i)).yi(indsReal(end)),['T ' num2str(keyTsect(i))],'color','w')
    end
    clear indsReal
end
title('Post-Maria, Sept. 26','FontSize',14)
set(gca,'YLim',YL,'XLim',XL,'Clim',[-30 -21],'FontSize',8)
xlabel('m East (UTM Zone 17R)'),ylabel('m North (UTM Zone 17R)')

subplot(1,2,2)
mapshow([ImgDir '2008_01_28_HR.tif']),hold on
% mapshow([ImgDir '1999_1_26_Mtnzs.tif']),hold on
load([DirPath 'RTK_Survey_04_Prcsd_mat/DEM_Mtnzs_20171019.mat'])
pcolor(Xg_n,Yg_n,Zg_n),pcolor(Xg_s,Yg_s,Zg_s)
shading interp,colormap jet

for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    plot(T(keyTsect(i)).xi(indsReal),T(keyTsect(i)).yi(indsReal),'k','linewidth',1.5)
    clear indsReal
end
for i=1:5
    indsReal=find(isnan(T(keyTsect(i)).zi)==0);
    if sum(indsReal)>0
        text(T(keyTsect(i)).xi(indsReal(end)),T(keyTsect(i)).yi(indsReal(end)),['T ' num2str(keyTsect(i))],'color','w')
    end
    clear indsReal
end
title('Recovery(?), Oct. 19','FontSize',14)
set(gca,'YLim',YL,'XLim',XL,'Clim',[-30 -21],'FontSize',8)
xlabel('m East (UTM Zone 17R)'),ylabel('m North (UTM Zone 17R)')
%% Print the Recovery DEMs figure
print('-r300','-dpng',['/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/FigDumps/DEMs_2_Recovery_' section '.png'])

