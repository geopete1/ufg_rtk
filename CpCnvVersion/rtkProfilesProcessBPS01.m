function rtkProfilesProcessBPS01(DateStr,DateStr2,sle,x_sp_m,xs_int_m)
%% Import and Plot .xlsx transect data from Rich's CpCnv spreadsheets
% Script for importing data from the following spreadsheet:
%
%    Workbook:
%    /Users/pna/Data/Data_III_ELEV/DGPS_data/CpCnv/XSec/CpCnv_090707_XSec.xlsx
%    Worksheet: CpCnv_090707_Xsec
%
% To extend the code for use with different selected data or a different
% spreadsheet, generate a function instead of a script.

% Auto-generated by MATLAB on 2014/11/19 09:41:33
% Edited by PNA at UF on 2014/11/19 & 2014/11/20
%% Make Fresh
close all

%% Import the data
DataDir='/Users/pna/Dropbox/Data/Data01_CpCnv/';
% DataDir2='/Users/pna/Dropbox/Data/CpCnv/';
% DateStr='090707';     % Transects Survey
% DateStr2='20090706';  % ATV Survey

[~, ~, raw] = xlsread([DataDir 'BackPackSurveys/CpCnv_' DateStr '_XSec.xlsx'],...
    ['CpCnv_' DateStr '_Xsec']);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,6,12]);
raw = raw(:,[1,3,4,5,7,8,9,10,11]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
ID = data(:,1);
Point = cellVectors(:,1);
N_UTM_N83m_Y = data(:,2);
E_UTM_N83m_X = data(:,3);
NADV88_m = data(:,4);
Code = cellVectors(:,2);
Hz_Prec_m = data(:,5);
Vt_Prec_m = data(:,6);
PDOP = data(:,7);
Sats = data(:,8);
Date_EST = data(:,9);
Time_EST = cellVectors(:,3);

%% Clear temporary variables
clearvars data raw cellVectors R;

%% Load reference data
load([DataDir 'matDataReferenceFeatures/KSC_TransectIDs.mat']);
load([DataDir 'matDataReferenceFeatures/Transects.mat'])
load([DataDir 'matDataReferenceFeatures/DuneLine.mat'])
load([DataDir 'matDataProcessedDEMs/DEM_CpCnv_' DateStr2 '.mat'])

%% Modify the UFT_IDs to remove zeros from those north of UFT_ID=100
for i=1:length(UFT_ID)
    if strcmp(UFT_ID{i}(1),'0')
        UFT_ID{i}=UFT_ID{i}(end-1:end);
    end
end

%% Parse out the indices of the various transects
% Need to do some replacements of inconsistent text in the .xls data files
if sum(strcmp(DateStr,{'090906','100828'}))>0
    search_str='xsec';
elseif sum(strcmp(DateStr,{'091006','120604'}))>0
    search_str='UF_XSec_';
else
    search_str='UF_Xsec_';
end
% Identify the indicies of the .xls data that correspond to each transect
for i=1:length(UFT_ID)
    ind{i}=find(strcmp(Code,[search_str UFT_ID{i}])==1);
end

%% Calculate walked profile details
D_proj=cell(1,13);
for i=1:length(ind)
    % Calculate projected positions of walked data along closest DSAS transect
    for j=1:length(E_UTM_N83m_X(ind{i}))
        [E_UTM_X_proj{i}(j),N_UTM_Y_proj{i}(j)]=...
            mapsPt2Line(EndX(str2num(DSAS_ID{i})),StartX(str2num(DSAS_ID{i})),...
            EndY(str2num(DSAS_ID{i})),StartY(str2num(DSAS_ID{i})),...
            E_UTM_N83m_X(ind{i}(j)),N_UTM_N83m_Y(ind{i}(j)));
    end
    % Calculate position along transect that each projected point occupies
    if isempty(ind{i})==0
        D_proj{i}=cumsum(sqrt((diff([EndX(str2num(DSAS_ID{i})) E_UTM_X_proj{i}]).^2)+...
            (diff([EndY(str2num(DSAS_ID{i})) N_UTM_Y_proj{i}]).^2)));
    end
    
    % Record the profile details into the familiar "T" structure
    if isempty(ind{i})==0,
        T_BPS(i).x=E_UTM_N83m_X(ind{i});
        T_BPS(i).xproj=E_UTM_X_proj{i};
        T_BPS(i).y=N_UTM_N83m_Y(ind{i});
        T_BPS(i).yproj=N_UTM_Y_proj{i};
        T_BPS(i).z=NADV88_m(ind{i});
        T_BPS(i).dproj=D_proj{i};
        % Compute the shift of the walked transect relative to the Dune crest
        d2DptsDSAS=sqrt(((T_BPS(i).xproj-DuneX(str2num(DSAS_ID{i}))).^2)+...
            ((T_BPS(i).yproj-DuneY(str2num(DSAS_ID{i}))).^2));
        indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
        DshiftDSAS=DuneD(333);
%         DshiftDSAS=sqrt(((T_BPS(i).xproj(indDuneDSAS)-T_BPS(i).xproj(1))^2)+...
%             ((T_BPS(i).yproj(indDuneDSAS)-T_BPS(i).yproj(1))^2));
        T_BPS(i).ddproj=T_BPS(i).dproj-DshiftDSAS;
    else
        T_BPS(i).x=[];
        T_BPS(i).xproj=[];
        T_BPS(i).y=[];
        T_BPS(i).yproj=[];
        T_BPS(i).z=[];
        T_BPS(i).dproj=[];
        T_BPS(i).ddproj=[];
    end

end

%% Calculate slopes of profiles
% First, for walked profiles (WAIT! CAN'T DO THIS UNTIL XPOSITIONS ARE EVENLY-SPACED)
% for i=1:length(ind)
%     x=D_proj{i};
%     z=NADV88_m(ind{i});
%     [ind_sl m x_fit slp_fit]=dgpsFindBchSlope(x,z,sle,x_sp_m,xs_int_m);
% end
% Then, for interp'd profiles
for i=1:length(ind)
    xi=T(str2num(DSAS_ID{i})).di;
    zi=T(str2num(DSAS_ID{i})).zi; zi=zi';
    [ind_sl m x_fit slp_fit]=dgpsFindBchSlope(xi,zi,sle,x_sp_m,xs_int_m);
end

%% Plot each of the transect map-view positions
hf1=figure;
for i=1:length(ind)
    subplot(4,4,i)
    plot(E_UTM_N83m_X(ind{i}),N_UTM_N83m_Y(ind{i}),'b.')
    hold on
    plot([EndX(str2num(DSAS_ID{i})) StartX(str2num(DSAS_ID{i}))],...
        [EndY(str2num(DSAS_ID{i})) StartY(str2num(DSAS_ID{i}))],'r--')
    axis equal,grid on
    if isempty(ind{i})==0
        set(gca,'XLim',[min(E_UTM_N83m_X(ind{i})) max(E_UTM_N83m_X(ind{i}))],...
            'YLim',[min(N_UTM_N83m_Y(ind{i})) max(N_UTM_N83m_Y(ind{i}))])
    end
    set(gca,'box','on')
    title(['UF Transect ID ' UFT_ID{i}])
end

%% Plot profiles (1.Walked Profiles proj'd onto DSAS line & 2.DSAS interp'd)
hf2=figure;
for i=1:length(ind)
    subplot(4,4,i),hold on
    plot(D_proj{i},NADV88_m(ind{i}),'linewidth',2)
    x_i=T(str2num(DSAS_ID{i})).di;
    z_i=T(str2num(DSAS_ID{i})).zi; z_i=z_i';
    plot(x_i,z_i,'r-','linewidth',2)
    grid on
    XlimitsLandward=[190 170 160 120 140 140 160 160 140 160 205 220 225]';
    XlimitsSeaward=[310 290 280 240 260 260 280 280 260 280 325 340 345]';
    XlimitsArray=[XlimitsLandward XlimitsSeaward];
    set(gca,'XLim',XlimitsArray(i,:),'YLim',[-2 5],'box','on','fontsize',8)
    title(['UF Transect ' UFT_ID{i}],'fontsize',10)
    xlabel('Dist. along transect (m)','fontsize',8)
    ylabel('Elev. (m)','fontsize',8)
end

text(420,2,['KSC Transect Profiles: 20' DateStr(1:2) '-' DateStr(3:4) '-' ...
    DateStr(5:6)],'fontsize',20);
%% Printing Details
set(hf1,'units','normalized','position',[0.05 0.05 0.45 0.8])
set(hf2,'units','normalized','position',[0.5 0.05 0.45 0.8])
set(hf2,'units','inches','papersize',[9 6.5],'paperposition',[0 0 9 6.5])

print(hf2,'-dpdf',[DataDir 'matFigs_ProfileComparisons/' DateStr2 ...
    'KSC_profiles_compare.pdf']);

save([DataDir 'matDataProfilesBackPack/ProfilesCpCnv_BPS_20' DateStr '.mat'],'T_BPS');

% save([DataDir 'matDataProfilesBackPack/Xsec_CpCnv_' DateStr '.mat'],...
%     'D_proj','DSAS_ID','ind','E_UTM_N83m_X','E_UTM_X_proj',...
%     'N_UTM_N83m_Y','N_UTM_Y_proj','NADV88_m','T_BPS');
