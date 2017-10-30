close all,clear all

RefFeatDir='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/';
load([RefFeatDir 'KSC_SurvDates.mat']);

% ClnDataDir='/Volumes/Geo-Adams-Share/Data/Data01_RTK/RTK_Survey_Clean_PNA/';
ClnDataDir='/Users/pna/Dropbox/Data/Data01_CpCnv/RTK_Survey_Clean_PNA/';
% PcsdDataDir='/Volumes/Geo-Adams-Share/Data/Data01_RTK/RTK_Survey_Prcsd_PNA/';
PcsdDataDir='/Users/pna/Dropbox/Data/Data01_CpCnv/RTK_Survey_Prcsd_PNA/';

for i=[74:78]
    rtkCpCnvProcess01(srvdts_6dig_str{i},ClnDataDir,RefFeatDir,PcsdDataDir)
%     close all
end

