%% rtkProfilesProcessOlson.m
% Script to import, reformat, and save beach topographic profile data
% collected by Morgan and Eklund, subcontractors to Olson Engineering, in
% late January and early February of 2012, in preparation for the
% emplacement of the "Sandy" Dune at KSC.
%
% by PNA at UF during the Fall of 2016
%
%% Intro Code
% Start with a clean slate
close all,clearvars
%%
% Import my custom colors
set_pna_colors;
%%
% Identify the directory locations of the various profile data
Olson_data_dir='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataProfilesOlson2012/';
RefFeat_data_dir='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataReferenceFeatures/';
Hurricane_data_dir='/Users/pna/Dropbox/Publications/JournalManuscripts/MsXX_CpCnv_IreneVsSandy/Data/';
%% Prepare the Data
% Open and read in the Olson data transects
fid=fopen([Olson_data_dir '5247-77.XYZ'],'r');
D=textscan(fid,'%n %n %n','headerlines',25);
fclose(fid);
e=D{1}; n=D{2}; z=D{3}*0.3048;
%%
% Convert the Olson data from state plane feet to UTM meters with a 
% combination of sp_proj and mapsLatLong2UTM fcns
[long lat]=sp_proj('florida east','inverse',e,n,'survey feet');
[OlsProf_utmN,OlsProf_utmE]=mapsLatLong2UTM(lat,long,23,'17R');
%% Partition the Olson data into transects 
% The Olson transects are provided as one, continuous list of x-y-z data,
% that snake back and forth (up and down the beach).  This technique breaks
% up the data, by finding the indices where there is a greater than 50m
% difference between two adjacent northing measurements.
%%
% First, plot the transect break indices
figure
subplot(2,1,1),plot(diff(e),'+'),set(gca,'FontSize',12),grid on
ylabel({'Diff. Adjacent';'Easting Values (m)'},'FontSize',12) 
subplot(2,1,2),plot(diff(n),'+'),set(gca,'FontSize',12),grid on
xlabel('Index of Data Point in Olson Data Set','FontSize',12) 
ylabel({'Diff. Adjacent';'Northing Values (m)'},'FontSize',12)
%%
% Next, identify and save the transect break indices
brks=find(abs(diff(n))>50);
num_Ols_tsects=length(brks);
%%
% Identify the transect ids that increment upwards from offshore to
% onshore. This can only be done by examining the documentation that 
% accompanied the Olson (Morgan and Ecklund) profile report.
s1={'65','67','69','71','73','75','77','79','81','83','85','87','89',...
    '91','93','95','97','99'};
%%
% Loop through the profiles, flipping the shoreward orienting ones, and
% record xi, yi, zi, di, and id fields for each transect into the T_OLS
% structure
pr_beg_ind=1;
for i=1:num_Ols_tsects
    h=63+i;
    % Flip, then record, the transects that increment upwards from offshore
    % to onshore (odd-numbered in Olson scheme)
    if sum(strcmp(num2str(h),s1))>0
        T_OLS(i).xi=flipud(OlsProf_utmE(pr_beg_ind:brks(i)));
        T_OLS(i).yi=flipud(OlsProf_utmN(pr_beg_ind:brks(i)));
        T_OLS(i).zi=flipud(z(pr_beg_ind:brks(i)));
    % Simply record (without flipping) the transects that increment upwards
    % from offshore to onshore (even-numbered in Olson scheme)
    else
        T_OLS(i).xi=OlsProf_utmE(pr_beg_ind:brks(i));
        T_OLS(i).yi=OlsProf_utmN(pr_beg_ind:brks(i));
        T_OLS(i).zi=z(pr_beg_ind:brks(i));
    end
    % Compute cumulative distance along transect
    T_OLS(i).di=[0; cumsum(sqrt(((diff(T_OLS(i).xi)).^2)+((diff(T_OLS(i).yi)).^2)))];    
    % Record the transect Olson transect id string
    T_OLS(i).id=['V-' num2str(h)];
    % Create placeholders for cross shore position with respect to dune
    T_OLS(i).ddi=T_OLS(i).di;
    % increment to the index that marks the start of the next transect
    pr_beg_ind=brks(i)+1;
end
%% Plot Map View of Olson and DSAS Transects
figure
load([RefFeat_data_dir 'Transects.mat'])
for i=1:length(T_KSC)
    plot(T_KSC(i).xi,T_KSC(i).yi,'b'),hold on
end
for i=1:length(T_OLS)
    plot(T_OLS(i).xi,T_OLS(i).yi,'r'),hold on
end
axis equal
for i=1:length(T_OLS)
    plot(T_OLS(i).xi(1),T_OLS(i).yi(1),'ro','MarkerSize',10)
    plot(T_OLS(i).xi(end),T_OLS(i).yi(end),'ro','MarkerSize',10)
    Out(i,:)=[T_OLS(i).xi(1) T_OLS(i).yi(1) T_OLS(i).xi(end) T_OLS(i).yi(end)];
end

%%
% Plot Launchpads 39A and 39B 
plot(538711.22,3164660.68,'ko','MarkerSize',15,'markerfacecolor','y')
plot(537063.63,3166732.32,'ko','MarkerSize',15,'markerfacecolor','y')
grid on

%% Finding the D-shift:
% In this step, we are first associating the Olson transects, based on Fla.
% virtual monument numbers, with the closest available DSAS transects

%%
% Now find the dune location relative to the each "common" (Olson & DSAS)
% transect
load([RefFeat_data_dir 'DuneLine.mat'])
% load('/Users/pna/Dropbox/Data/Data01_CpCnv/matDataProcessedDEMs/DEM_CpCnv_20120210.mat')
% 
% for i=1:length(T)
%     % Create placeholders for cross shore position with respect to dune
%     T(i).ddi=(0./0).*T(i).di;
% end
%% Place a loop that shifts each Olson profile 
% Each profile's shift is a uniquely required distance, determined by 
% computing the difference between the landward-most point on the Olson
% profile and the "dune crest" UTM point on the corresponding DSAS Profile
Ols_t={'3','4','5','6','7','8','9',...
    '10','11','12','13','14','15','16','17','18','19',...
    '20','21','22','23','24','25','26','27','28','29',...
    '30','31','32','33','34'};
DSAS_t={'31','62','90','121','150','180','211',...
    '240','271','303','332','365','394','424','454','484','514',...
    '548','578','606','638','669','698','731','760','796','834',...
    '864','895','925','955','986'};

for i=1:length(Ols_t)
    d2DptsOls=sqrt(((T_OLS(str2num(Ols_t{i})).xi-DuneX(str2num(DSAS_t{i}))).^2)+...
        ((T_OLS(str2num(Ols_t{i})).yi-DuneY(str2num(DSAS_t{i}))).^2));
    indDuneOls=find(d2DptsOls==min(d2DptsOls));
    DshiftOls=sqrt(((T_OLS(str2num(Ols_t{i})).xi(indDuneOls)-T_OLS(str2num(Ols_t{i})).xi(1))^2)+...
        ((T_OLS(str2num(Ols_t{i})).yi(indDuneOls)-T_OLS(str2num(Ols_t{i})).yi(1))^2));
    T_OLS(str2num(Ols_t{i})).ddi=T_OLS(str2num(Ols_t{i})).di-DshiftOls;
end

save([Olson_data_dir 'Olson_Profiles_20120201.mat'],'T_OLS')

% %%
% % Show Region by Olson Line Number 7, V-70, DSAS 150, UFT 020 (151)
% DSAS_t=150; Ols_t=7; FL_vm='70'; UF_t='T020';
% Lnd_ext_vert_meas=find(~isnan(T(DSAS_t).zi));
% figure(2)
% plot(T_OLS(Ols_t).xi,T_OLS(Ols_t).yi,'b*')
% plot(T(DSAS_t).xi(Lnd_ext_vert_meas),T(DSAS_t).yi(Lnd_ext_vert_meas),'g*')
% plot(DuneX(DSAS_t-2:DSAS_t+2),DuneY(DSAS_t-2:DSAS_t+2),'k*','linewidth',2)
% %%
% % Find distance of all DSAS transect points to Dune crest at that transect
% d2DptsDSAS=sqrt(((T(DSAS_t).xi-DuneX(DSAS_t)).^2) +((T(DSAS_t).yi-DuneY(DSAS_t)).^2));
% %%
% % Find index of DSAS transect point closest to Dune crest
% indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
% %%
% % Compute shift = dist from pt closest to dune crest to most landward pt of transect
% DshiftDSAS=sqrt(((T(DSAS_t).xi(indDuneDSAS)-T(DSAS_t).xi(1))^2)+...
%     ((T(DSAS_t).yi(indDuneDSAS)-T(DSAS_t).yi(1))^2));
% T(DSAS_t).ddi=T(DSAS_t).di-DshiftDSAS;
% 
% d2DptsOls=sqrt(((T_OLS(Ols_t).xi-DuneX(DSAS_t)).^2) +((T_OLS(Ols_t).yi-DuneY(DSAS_t)).^2));
% indDuneOls=find(d2DptsOls==min(d2DptsOls));
% DshiftOls=sqrt(((T_OLS(Ols_t).xi(indDuneOls)-T_OLS(Ols_t).xi(1))^2)+...
%     ((T_OLS(Ols_t).yi(indDuneOls)-T_OLS(Ols_t).yi(1))^2));
% T_OLS(Ols_t).ddi=T_OLS(Ols_t).di-DshiftOls;
% 
% figure
% plot(T_OLS(Ols_t).di,T_OLS(Ols_t).zi,'--','color',color.grey),hold on
% plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2)
% 
% plot(T(DSAS_t).di,T(DSAS_t).zi,'--','color',color.darkgrey)
% plot(T(DSAS_t).ddi,T(DSAS_t).zi,'linewidth',2)
% grid on
% legend('Olson, unshift.','Olson, shifted','UF Data, unshift.','UF Data, shifted')
% xlabel('Cross-Shore Position (m, w.r.t. Dune Crest)')
% ylabel('Elevation (m)')
% title(['FL. V-' FL_vm ', DSAS ID:' num2str(DSAS_t) ', UF-' UF_t])
% set(gca,'XLim',[-300 1200],'YLim',[-12 6])
% %%
% % Show Region by Olson Line Number 13, V-76, DSAS 332, UFT 040 (333)
% DSAS_t=332; Ols_t=13; FL_vm='76'; UF_t='T040';
% Lnd_ext_vert_meas=find(~isnan(T(DSAS_t).zi));
% figure(2)
% plot(T_OLS(Ols_t).xi,T_OLS(Ols_t).yi,'b*')
% plot(T(DSAS_t).xi(Lnd_ext_vert_meas),T(DSAS_t).yi(Lnd_ext_vert_meas),'g*')
% plot(DuneX(DSAS_t-2:DSAS_t+2),DuneY(DSAS_t-2:DSAS_t+2),'k*','linewidth',2)
% 
% d2DptsDSAS=sqrt(((T(DSAS_t).xi-DuneX(DSAS_t)).^2) +((T(DSAS_t).yi-DuneY(DSAS_t)).^2));
% indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
% DshiftDSAS=sqrt(((T(DSAS_t).xi(indDuneDSAS)-T(DSAS_t).xi(1))^2)+...
%     ((T(DSAS_t).yi(indDuneDSAS)-T(DSAS_t).yi(1))^2));
% T(DSAS_t).ddi=T(DSAS_t).di-DshiftDSAS;
% 
% d2DptsOls=sqrt(((T_OLS(Ols_t).xi-DuneX(DSAS_t)).^2) +((T_OLS(Ols_t).yi-DuneY(DSAS_t)).^2));
% indDuneOls=find(d2DptsOls==min(d2DptsOls));
% DshiftOls=sqrt(((T_OLS(Ols_t).xi(indDuneOls)-T_OLS(Ols_t).xi(1))^2)+...
%     ((T_OLS(Ols_t).yi(indDuneOls)-T_OLS(Ols_t).yi(1))^2));
% T_OLS(Ols_t).ddi=T_OLS(Ols_t).di-DshiftOls;
% 
% figure
% plot(T_OLS(Ols_t).di,T_OLS(Ols_t).zi,'--','color',color.grey),hold on
% plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2)
% 
% plot(T(DSAS_t).di,T(DSAS_t).zi,'--','color',color.darkgrey)
% plot(T(DSAS_t).ddi,T(DSAS_t).zi,'linewidth',2)
% grid on
% legend('Olson, unshift.','Olson, shifted','UF Data, unshift.','UF Data, shifted')
% xlabel('Cross-Shore Position (m, w.r.t. Dune Crest)')
% ylabel('Elevation (m)')
% title(['FL. V-' FL_vm ', DSAS ID:' num2str(DSAS_t) ', UF-' UF_t])
% set(gca,'XLim',[-300 1200],'YLim',[-12 6])
% %%
% % Show Region by Olson Line Number 18, V-81, DSAS 484, UFT 070 (483)
% DSAS_t=484; Ols_t=18; FL_vm='81'; UF_t='T070';
% Lnd_ext_vert_meas=find(~isnan(T(DSAS_t).zi));
% figure(2)
% plot(T_OLS(Ols_t).xi,T_OLS(Ols_t).yi,'b*')
% plot(T(DSAS_t).xi(Lnd_ext_vert_meas),T(DSAS_t).yi(Lnd_ext_vert_meas),'g*')
% plot(DuneX(DSAS_t-2:DSAS_t+2),DuneY(DSAS_t-2:DSAS_t+2),'k*','linewidth',2)
% 
% d2DptsDSAS=sqrt(((T(DSAS_t).xi-DuneX(DSAS_t)).^2) +((T(DSAS_t).yi-DuneY(DSAS_t)).^2));
% indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
% DshiftDSAS=sqrt(((T(DSAS_t).xi(indDuneDSAS)-T(DSAS_t).xi(1))^2)+...
%     ((T(DSAS_t).yi(indDuneDSAS)-T(DSAS_t).yi(1))^2));
% T(DSAS_t).ddi=T(DSAS_t).di-DshiftDSAS;
% 
% d2DptsOls=sqrt(((T_OLS(Ols_t).xi-DuneX(DSAS_t)).^2) +((T_OLS(Ols_t).yi-DuneY(DSAS_t)).^2));
% indDuneOls=find(d2DptsOls==min(d2DptsOls));
% DshiftOls=sqrt(((T_OLS(Ols_t).xi(indDuneOls)-T_OLS(Ols_t).xi(1))^2)+...
%     ((T_OLS(Ols_t).yi(indDuneOls)-T_OLS(Ols_t).yi(1))^2));
% T_OLS(Ols_t).ddi=T_OLS(Ols_t).di-DshiftOls;
% 
% figure
% plot(T_OLS(Ols_t).di,T_OLS(Ols_t).zi,'--','color',color.grey),hold on
% plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2)
% 
% plot(T(DSAS_t).di,T(DSAS_t).zi,'--','color',color.darkgrey)
% plot(T(DSAS_t).ddi,T(DSAS_t).zi,'linewidth',2)
% grid on
% legend('Olson, unshift.','Olson, shifted','UF Data, unshift.','UF Data, shifted')
% xlabel('Cross-Shore Position (m, w.r.t. Dune Crest)')
% ylabel('Elevation (m)')
% title(['FL. V-' FL_vm ', DSAS ID:' num2str(DSAS_t) ', UF-' UF_t])
% set(gca,'XLim',[-300 1200],'YLim',[-12 6])
% %%
% % Show Region by Olson Line Number 20, V-83, DSAS 548, UFT 080 (549)
% DSAS_t=548; Ols_t=20; FL_vm='83'; UF_t='T080';
% Lnd_ext_vert_meas=find(~isnan(T(DSAS_t).zi));
% figure(2)
% plot(T_OLS(Ols_t).xi,T_OLS(Ols_t).yi,'b*')
% plot(T(DSAS_t).xi(Lnd_ext_vert_meas),T(DSAS_t).yi(Lnd_ext_vert_meas),'g*')
% plot(DuneX(DSAS_t-2:DSAS_t+2),DuneY(DSAS_t-2:DSAS_t+2),'k*','linewidth',2)
% 
% d2DptsDSAS=sqrt(((T(DSAS_t).xi-DuneX(DSAS_t)).^2) +((T(DSAS_t).yi-DuneY(DSAS_t)).^2));
% indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
% DshiftDSAS=sqrt(((T(DSAS_t).xi(indDuneDSAS)-T(DSAS_t).xi(1))^2)+...
%     ((T(DSAS_t).yi(indDuneDSAS)-T(DSAS_t).yi(1))^2));
% T(DSAS_t).ddi=T(DSAS_t).di-DshiftDSAS;
% 
% d2DptsOls=sqrt(((T_OLS(Ols_t).xi-DuneX(DSAS_t)).^2) +((T_OLS(Ols_t).yi-DuneY(DSAS_t)).^2));
% indDuneOls=find(d2DptsOls==min(d2DptsOls));
% DshiftOls=sqrt(((T_OLS(Ols_t).xi(indDuneOls)-T_OLS(Ols_t).xi(1))^2)+...
%     ((T_OLS(Ols_t).yi(indDuneOls)-T_OLS(Ols_t).yi(1))^2));
% T_OLS(Ols_t).ddi=T_OLS(Ols_t).di-DshiftOls;
% 
% figure
% plot(T_OLS(Ols_t).di,T_OLS(Ols_t).zi,'--','color',color.grey),hold on
% plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2)
% 
% plot(T(DSAS_t).di,T(DSAS_t).zi,'--','color',color.darkgrey)
% plot(T(DSAS_t).ddi,T(DSAS_t).zi,'linewidth',2)
% grid on
% legend('Olson, unshift.','Olson, shifted','UF Data, unshift.','UF Data, shifted')
% xlabel('Cross-Shore Position (m, w.r.t. Dune Crest)')
% ylabel('Elevation (m)')
% title(['FL. V-' FL_vm ', DSAS ID:' num2str(DSAS_t) ', UF-' UF_t])
% set(gca,'XLim',[-300 1200],'YLim',[-12 6])
% %%
% % Show Region by Olson Line Number 29, V-92, DSAS 834, UFT 110 (836)
% DSAS_t=834; Ols_t=29; FL_vm='92'; UF_t='T110';
% Lnd_ext_vert_meas=find(~isnan(T(DSAS_t).zi));
% figure(2)
% plot(T_OLS(Ols_t).xi,T_OLS(Ols_t).yi,'b*')
% plot(T(DSAS_t).xi(Lnd_ext_vert_meas),T(DSAS_t).yi(Lnd_ext_vert_meas),'g*')
% plot(DuneX(DSAS_t-2:DSAS_t+2),DuneY(DSAS_t-2:DSAS_t+2),'k*','linewidth',2)
% 
% d2DptsDSAS=sqrt(((T(DSAS_t).xi-DuneX(DSAS_t)).^2) +((T(DSAS_t).yi-DuneY(DSAS_t)).^2));
% indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
% DshiftDSAS=sqrt(((T(DSAS_t).xi(indDuneDSAS)-T(DSAS_t).xi(1))^2)+...
%     ((T(DSAS_t).yi(indDuneDSAS)-T(DSAS_t).yi(1))^2));
% T(DSAS_t).ddi=T(DSAS_t).di-DshiftDSAS;
% 
% d2DptsOls=sqrt(((T_OLS(Ols_t).xi-DuneX(DSAS_t)).^2) +((T_OLS(Ols_t).yi-DuneY(DSAS_t)).^2));
% indDuneOls=find(d2DptsOls==min(d2DptsOls));
% DshiftOls=sqrt(((T_OLS(Ols_t).xi(indDuneOls)-T_OLS(Ols_t).xi(1))^2)+...
%     ((T_OLS(Ols_t).yi(indDuneOls)-T_OLS(Ols_t).yi(1))^2));
% T_OLS(Ols_t).ddi=T_OLS(Ols_t).di-DshiftOls;
% 
% figure
% plot(T_OLS(Ols_t).di,T_OLS(Ols_t).zi,'--','color',color.grey),hold on
% plot(T_OLS(Ols_t).ddi,T_OLS(Ols_t).zi,'linewidth',2)
% 
% plot(T(DSAS_t).di,T(DSAS_t).zi,'--','color',color.darkgrey)
% plot(T(DSAS_t).ddi,T(DSAS_t).zi,'linewidth',2)
% grid on
% legend('Olson, unshift.','Olson, shifted','UF Data, unshift.','UF Data, shifted')
% xlabel('Cross-Shore Position (m, w.r.t. Dune Crest)')
% ylabel('Elevation (m)')
% title(['FL. V-' FL_vm ', DSAS ID:' num2str(DSAS_t) ', UF-' UF_t])
% set(gca,'XLim',[-300 1200],'YLim',[-12 6])
