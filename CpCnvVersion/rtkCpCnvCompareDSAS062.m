close all,clear all
load('/Users/pna/Dropbox/Data/Data01_CpCnv/matDataProfilesOlson2012/Olson_Profiles_20120201.mat')
load('/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/KSC_SurvDates.mat')

DSAS_t=31; Ols_t=3;

DataDirATVprofiles='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataProfilesATV/'
figure('units','inches','position',[2 8 20 10])
plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2),hold on,grid on
for i=46
    i
    load([DataDirATVprofiles 'ProfilesCpCnv_ATV_20' srvdts_6dig_str{i} '.mat'])
    plot(T_ATV(DSAS_t).ddi,T_ATV(DSAS_t).zi,'linewidth',2)
    drawnow,pause(0.1)
end
