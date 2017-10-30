function [PX_n PY_n PX_s PY_s]=rtkCpCnvProcess01b_getPolygons(surveydate,...
    RefFeatDir,East_cl_10cm,North_cl_10cm,K_10cm)
%
% Function to convert .shp file, of clipped polygon that bounds the survey
% extent, to a .mat file.  The arc polygon files are located (on the
% server) at /Volumes/Observations/CpCnv/Data/GIS/Work/, but locally, I
% store them at /Users/pna/Data/Data_III_ELEV/DGPS_data/CpCnv/Clip_Polygon/
% 
% Extracted from previous code by pna in Van, Feb. 29, 2012
% Rewired on the airplane to PA, Jul. 29, 2016
%% 
disp('Running function rtkCpCnvProcess01b_getPolygons.m')

%% Load the regional boxes
load([RefFeatDir 'NrthBox.mat']) 
load([RefFeatDir 'SthBox.mat'])
PX=East_cl_10cm(K_10cm); PY=North_cl_10cm(K_10cm);
% Identify polygon points in north and south boxes portions of KSC coast
IN_n=inpoly([PX(:) PY(:)],[NrthBoxPoly_x(:) NrthBoxPoly_y(:)]);
IN_s=inpoly([PX(:) PY(:)],[SthBoxPoly_x(:) SthBoxPoly_y(:)]);
PX_n=PX(IN_n); PY_n=PY(IN_n);
PX_s=PX(IN_s); PY_s=PY(IN_s);

% Show the full polygon and the regional boxes
figure('units','inches','position',[1 1 5 10])
plot(PX,PY,'r','linewidth',2),hold on,grid on,axis equal
plot(NrthBoxPoly_x,NrthBoxPoly_y,'m','linewidth',2)
plot(SthBoxPoly_x,SthBoxPoly_y,'g','linewidth',2)
title('Clipping Boxes and Full Polygon')

%% Old Legacy Code
% % INITIALIZE
% 
% surveydn=datenum(['20' surveydate(1:2) '-' surveydate(3:4) '-' surveydate(5:6)]);
% polystylechangedate=datenum('2012-11-29');
% % Identify the directory containing the polygon .shp file
% % sd=['/Users/pna/Data/Data_III_ELEV/DGPS_data/CpCnv/Clip_Polygon/']; % (MacPro)
% % sd=['/Users/pna/Desktop/DGPS_data/CpCnv/Clip_Polygon/']; % (MacBookAir)
% 
% % Identify the location for .mat output files
% sd_out=['/Users/pna/Desktop/'];
% 
% % Load the regional boxes
% load('/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/NrthBox.mat') % (MacPro)
% load('/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/SthBox.mat') % (MacPro)
% % load('/Users/pna/Desktop/DGPS_data/CpCnv/NrthBox.mat') % (MacBookAir)
% % load('/Users/pna/Desktop/DGPS_data/CpCnv/SthBox.mat') % (MacBookAir)
% 
% %% RUN
% % Convert the full (10km-long) polygon from .shp file (or a .txt file)
% data_dir='/Users/pna/Dropbox/Data/Data01_CpCnv/';
% if surveydn<polystylechangedate
%     sd=[data_dir 'Clip_Polygon/'];
%     P=shaperead([sd 'CpCnv_' surveydate '_Poly.shp']);
% %     P=shaperead([sd 'CpCnv_' surveydate '_Clip.shp']);
%     PX=P.X; PY=P.Y;
% else
%     sd=[data_dir 'Clip_Polygon_txt/'];
%     [PX,PY]=textread([sd 'CpCnv_' surveydate '_FinalPolygonPts.txt'],'%f %f','headerlines',1);
%     PX=PX'; PY=PY';
% end
% 
% % Identify polygon points in north and south boxes portions of KSC coast
% IN_n=inpoly([PX(:) PY(:)],[NrthBoxPoly_x(:) NrthBoxPoly_y(:)]);
% IN_s=inpoly([PX(:) PY(:)],[SthBoxPoly_x(:) SthBoxPoly_y(:)]);
% PX_n=PX(IN_n); PY_n=PY(IN_n);
% PX_s=PX(IN_s); PY_s=PY(IN_s);
% 
% % Save the regional polygons
% % cmndstr1=['save(''' sd_out 'NrthPoly_' surveydate '.mat'',''PX_n'',''PY_n'',''-mat'')'];
% % eval(cmndstr1)
% % cmndstr2=['save(''' sd_out 'SthPoly_' surveydate '.mat'',''PX_s'',''PY_s'',''-mat'')'];
% % eval(cmndstr2)
% 
% %% FINALIZE


