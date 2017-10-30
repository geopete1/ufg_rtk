function [Y X Z East_cl_10cm North_cl_10cm K_10cm]=...
    rtkProcess01a_loadmat(datadir,surveydate)
%
% Function to convert a dGPS beach survey data file (point cloud) from .csv
% to .mat files.
%
% By pna at UF Dec. 3, 2009
% Improved by pna at UF, Apr. 21, 2010
% Generalized in the van, Feb. 29, 2012
% Rewired on the airplane to PA, Jul. 29, 2016
%%
disp('Running function rtkProcess01a_loadmat.m')
%%

load([datadir 'CleanSurveyData_' surveydate '.mat'])
X=East_cl_10cm; Y=North_cl_10cm; Z=Elev_cl_10cm;

%% Old Legacy Code
% Identify the directory and filename of the .csv data file
% % sd=['/Users/pna/Desktop/DGPS_data/CpCnv/Bch_10cm/CSV/']; % (MacBookAir)
% % sd=['/Volumes/Observations/CpCnv_New/Data/GPS/Bch_10cm/CSV/']; % (Server)
% % sd=['/Users/pna/Data/Data_III_ELEV/DGPS_data/CpCnv/Bch_' res 'cm/CSV/']; % (MacPro)
% data_direc='/Users/pna/Dropbox/Data/Data01_CpCnv/';
% sd=[data_direc 'csvData_Bch' res 'cm/']; % (iMac 2016)
% if strcmp(res,'05')
%     filename=[sd 'CpCnv_' surveydate '_QC_Bch.csv'];
% elseif strcmp(res,'10')
%     filename=[sd 'CpCnv_' surveydate '_Bch_Edit.csv'];
% end
% 
% % Identify the location for .mat output files
% sd_out=['/Users/pna/Desktop/'];
% % sd_out=['/Users/pna/Data/Data_III_ELEV/DGPS_data/CpCnv/matFilesSurveyPts/Bch_QC_data/'];
% 
% % Convert the ...QC_Bch (main survey) files
% [ptid,ptnum,Y,X,Z,ptname,HzPrec,VtPrec,PDOP,Sats,Date,Time]=...
%     textread(filename,'%s %s %f %f %f %s %s %s %s %s %s %s','headerlines',2,'delimiter',',');
% 
% % Save the .mat file
% % save([sd_out 'CpCnv_' surveydate '_QC_Bch.mat'],'X','Y','Z')
% 
% %************************************************************************
% %% Code to convert DSAS transects to .mat file - used Sept. 2010 for CpCnv Work 
% % file=['/Users/pna/Desktop/Transects.txt'];
% % [OBJECTID,BaselineID,Group_,TransOrder,ProcTime,Autogen,StartX,StartY,EndX,EndY,Azimuth,SHAPE_Length]=...
% %     textread([file],'%s %s %s %s %s %s %f %f %f %f %s %s','headerlines',1,'delimiter',',');
% % save(['/Users/pna/Desktop/Transects.mat'],'StartX','StartY','EndX','EndY')
