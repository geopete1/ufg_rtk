close all,clear all

% BaseDir='/Users/pna/Dropbox/SharedFolders/Shared_Matanzas_HurricaneIrma/';
BaseDir='/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/';

% RefFeatDir='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/';
RefFeatDir=[BaseDir 'Data_Reference/'];

load([RefFeatDir 'Mtnzs_SurvDates.mat']);

% ClnDataDir='/Volumes/Geo-Adams-Share/Data/Data01_RTK/RTK_Survey_Clean_PNA/';
% ClnDataDir='/Users/pna/Dropbox/Data/Data01_CpCnv/RTK_Survey_Clean_PNA/';
ClnDataDir=[BaseDir 'RTK_Survey_03_Clean_mat/'];
% PcsdDataDir='/Volumes/Geo-Adams-Share/Data/Data01_RTK/RTK_Survey_Prcsd_PNA/';
% PcsdDataDir='/Users/pna/Dropbox/Data/Data01_CpCnv/RTK_Survey_Prcsd_PNA/';
PcsdDataDir=[BaseDir 'RTK_Survey_04_Prcsd_mat/'];


for i=[4]
    rtkProcess01(srvdts_6dig_str{i},ClnDataDir,RefFeatDir,PcsdDataDir)
%     close all
end

