function rtkCpCnvDataPrep01_Import(surveydatestr,genl_path,raw_dir,clean_dir)
close all
tic
%% Handle the dates (If running as a script, set the survey date)
date_str=[surveydatestr(1:2) surveydatestr(4:5) surveydatestr(7:8)]
dateForTitles=datestr(datetime(date_str,'InputFormat','yyMMdd'),'mmm-dd-yyyy');
%% Define the paths to the unified files
loc_id='mtnzs_n_';
path_raw_text=[genl_path raw_dir];
r27exist=0; r13exist=0; r64exist=0; r20exist=0;

if exist([path_raw_text loc_id date_str '_r27.txt'])==2
    disp('We have _r27 data')
    r27exist=1;
else
    disp('We do not have _r27 data')
end

if exist([path_raw_text loc_id date_str '_r13.txt'])==2
    disp('We have _r13 data')
    r13exist=1;
else
    disp('We do not have _r13 data')
end

if exist([path_raw_text loc_id date_str '_r64.txt'])==2
    disp('We have _r64 data')
    r64exist=1;
else
    disp('We do not have _r64 data')
end

if exist([path_raw_text loc_id date_str '_r20.txt'])==2
    disp('We have _r20 data')
    r20exist=1;
else
    disp('We do not have _r20 data')
end
%% Construct the full filename strings for the DOP & Pts files
filename_r27_Unified=[path_raw_text loc_id date_str '_r27.txt'];
filename_r13_Unified=[path_raw_text loc_id date_str '_r13.txt'];
filename_r64_Unified=[path_raw_text loc_id date_str '_r64.txt'];
filename_r20_Unified=[path_raw_text loc_id date_str '_r20.txt'];
t01=toc; disp([num2str(round(t01*10)/10) ' sec = set up and inspect files (total=' num2str(round(t01*10)/10) ' sec)'])
%% Import the unified files for all rovers (T-9/26/17)
if r27exist==1
    [PtID_r27,North_r27,East_r27,Elev_r27,Code_r27,HzPrec_r27,VtPrec_r27,...
        PDOP_r27,HDOP_r27,VDOP_r27,SATS_r27,AntHeight_r27,PtTime_r27]=...
        rtkDataPrep01c_importUnified2(filename_r27_Unified);
end
t02=toc; disp([num2str(round((t02-t01)*10)/10) ' sec = import r27 (total=' num2str(round(t02*10)/10) ' sec)'])

if r13exist==1
    [PtID_r13,North_r13,East_r13,Elev_r13,Code_r13,HzPrec_r13,VtPrec_r13,...
        PDOP_r13,HDOP_r13,VDOP_r13,SATS_r13,AntHeight_r13,PtTime_r13]=...
        rtkDataPrep01c_importUnified2(filename_r13_Unified);
end
t03=toc; disp([num2str(round((t03-t02)*10)/10) ' sec = import r13 (total=' num2str(round(t03*10)/10) ' sec)'])

if r64exist==1
    [PtID_r64,North_r64,East_r64,Elev_r64,Code_r64,HzPrec_r64,VtPrec_r64,...
        PDOP_r64,HDOP_r64,VDOP_r64,SATS_r64,AntHeight_r64,PtTime_r64]=...
        rtkDataPrep01c_importUnified2(filename_r64_Unified);
end

t04=toc; disp([num2str(round((t04-t03)*10)/10) ' sec = import r64 (total=' num2str(round(t04*10)/10) ' sec)'])
if r20exist==1
    [PtID_r20,North_r20,East_r20,Elev_r20,Code_r20,HzPrec_r20,VtPrec_r20,...
        PDOP_r20,HDOP_r20,VDOP_r20,SATS_r20,AntHeight_r20,PtTime_r20]=...
        rtkDataPrep01c_importUnified2(filename_r20_Unified);
end
t05=toc; disp([num2str(round((t05-t04)*10)/10) ' sec = import r20 (total=' num2str(round(t05*10)/10) ' sec)'])
%% Remove the ends of the transects (programmed into controllers)
if r27exist==1
    last_r27=max(find(isnan(Elev_r27)~=1));
    PtID_r27=PtID_r27(1:last_r27); North_r27=North_r27(1:last_r27); East_r27=East_r27(1:last_r27); 
    Elev_r27=Elev_r27(1:last_r27); HzPrec_r27=HzPrec_r27(1:last_r27); VtPrec_r27=VtPrec_r27(1:last_r27);
    PDOP_r27=PDOP_r27(1:last_r27); HDOP_r27=HDOP_r27(1:last_r27);
    VDOP_r27=VDOP_r27(1:last_r27); SATS_r27=SATS_r27(1:last_r27);
    AntHeight_r27=AntHeight_r27(1:last_r27); PtTime_r27=PtTime_r27(1:last_r27);
else
    last_r27=[]; PtID_r27=[]; North_r27=[]; East_r27=[]; Elev_r27=[];
    HzPrec_r27=[]; VtPrec_r27=[]; PDOP_r27=[]; HDOP_r27=[]; VDOP_r27=[];
    SATS_r27=[]; AntHeight_r27=[]; PtTime_r27=[];
end

if r13exist==1
    last_r13=max(find(isnan(Elev_r13)~=1));
    PtID_r13=PtID_r13(1:last_r13); North_r13=North_r13(1:last_r13); East_r13=East_r13(1:last_r13); 
    Elev_r13=Elev_r13(1:last_r13); HzPrec_r13=HzPrec_r13(1:last_r13); VtPrec_r13=VtPrec_r13(1:last_r13);
    PDOP_r13=PDOP_r13(1:last_r13); HDOP_r13=HDOP_r13(1:last_r13);
    VDOP_r13=VDOP_r13(1:last_r13); SATS_r13=SATS_r13(1:last_r13);
    AntHeight_r13=AntHeight_r13(1:last_r13); PtTime_r13=PtTime_r13(1:last_r13);
else
    last_r13=[]; PtID_r13=[]; North_r13=[]; East_r13=[]; Elev_r13=[];
    HzPrec_r13=[]; VtPrec_r13=[]; PDOP_r13=[]; HDOP_r13=[]; VDOP_r13=[];
    SATS_r13=[]; AntHeight_r13=[]; PtTime_r13=[];
end

if r64exist==1
    last_r64=max(find(isnan(Elev_r64)~=1));
    PtID_r64=PtID_r64(1:last_r64); North_r64=North_r64(1:last_r64); East_r64=East_r64(1:last_r64); 
    Elev_r64=Elev_r64(1:last_r64); HzPrec_r64=HzPrec_r64(1:last_r64); VtPrec_r64=VtPrec_r64(1:last_r64);
    PDOP_r64=PDOP_r64(1:last_r64); HDOP_r64=HDOP_r64(1:last_r64);
    VDOP_r64=VDOP_r64(1:last_r64); SATS_r64=SATS_r64(1:last_r64);
    AntHeight_r64=AntHeight_r64(1:last_r64); PtTime_r64=PtTime_r64(1:last_r64);
else
    last_r64=[]; PtID_r64=[]; North_r64=[]; East_r64=[]; Elev_r64=[];
    HzPrec_r64=[]; VtPrec_r64=[]; PDOP_r64=[]; HDOP_r64=[]; VDOP_r64=[];
    SATS_r64=[]; AntHeight_r64=[]; PtTime_r64=[];
end

if r20exist==1
    last_r20=max(find(isnan(Elev_r20)~=1));
    PtID_r20=PtID_r20(1:last_r20); North_r20=North_r20(1:last_r20); East_r20=East_r20(1:last_r20); 
    Elev_r20=Elev_r20(1:last_r20); HzPrec_r20=HzPrec_r20(1:last_r20); VtPrec_r20=VtPrec_r20(1:last_r20);
    PDOP_r20=PDOP_r20(1:last_r20); HDOP_r20=HDOP_r20(1:last_r20);
    VDOP_r20=VDOP_r20(1:last_r20); SATS_r20=SATS_r20(1:last_r20);
    AntHeight_r20=AntHeight_r20(1:last_r20); PtTime_r20=PtTime_r20(1:last_r20);
else
    last_r20=[]; PtID_r20=[]; North_r20=[]; East_r20=[]; Elev_r20=[];
    HzPrec_r20=[]; VtPrec_r20=[]; PDOP_r20=[]; HDOP_r20=[]; VDOP_r20=[];
    SATS_r20=[]; AntHeight_r20=[]; PtTime_r20=[];
end

t06=toc; disp([num2str(round((t06-t05)*10)/10) ' sec = removed transect endpoints (total=' num2str(round(t06*10)/10) ' sec)'])

MpVwXlims=[477.6 478.2]; MpVwYlims=[3286.3 3287.7];
%% Plot the data points collected by each rover
figure(1)
set(gcf,'position',[1287 85 589 1256]);
plot(East_r27/1000,North_r27/1000,'r.'),hold on
plot(East_r13/1000,North_r13/1000,'g.')
plot(East_r64/1000,North_r64/1000,'b.'),grid on
plot(East_r20/1000,North_r20/1000,'c.'),grid on
axis equal,axis tight
title(['Raw Data Coverage: ' dateForTitles],'FontSize',14)
set(gca,'FontSize',12,'XLim',MpVwXlims,'YLim',MpVwYlims)
xlabel('km East (UTM Zone 17R)'),ylabel('km North (UTM Zone 17R)')
legend('r27','r13','r64','r20')

%% Print map view of the data point coded by controller id (e.g. r27)
figure(1),set(gcf,'units','inches','PaperPosition',[0 0 4.5 6.5],'PaperSize',[4.5 6.5])  
print('-dpng','-r600',[genl_path 'FigDumps/' loc_id '_DataPrepFig01_MapViewPtsCllctd_' date_str '.png'])
t07=toc; disp([num2str(round((t07-t06)*10)/10) ' sec = printed Pts. Collected Fig. (total=' num2str(round(t07*10)/10) ' sec)'])
%% Correct for errors unique to the survey (i.e. erroneous ant. heights, etc.)
rtkDataPrep01d_UniqueCorrections;
%% Merge data from all rovers into a single set of variables to be cleaned
PtID=[PtID_r27; PtID_r13; PtID_r64; PtID_r20];
PtTime=[PtTime_r27; PtTime_r13; PtTime_r64; PtTime_r20];
SATS=[SATS_r27; SATS_r13; SATS_r64; SATS_r20];
PDOP=[PDOP_r27; PDOP_r13; PDOP_r64; PDOP_r20];
HDOP=[HDOP_r27; HDOP_r13; HDOP_r64; HDOP_r20];
VDOP=[VDOP_r27; VDOP_r13; VDOP_r64; VDOP_r20];
North=[North_r27; North_r13; North_r64; North_r20];
East=[East_r27; East_r13; East_r64; East_r20];
Elev=[Elev_r27; Elev_r13; Elev_r64; Elev_r20];
HzPrec=[HzPrec_r27; HzPrec_r13; HzPrec_r64; HzPrec_r20];
VtPrec=[VtPrec_r27; VtPrec_r13; VtPrec_r64; VtPrec_r20];
t08=toc; disp([num2str(round((t08-t07)*10)/10) ' sec = merged data (total=' num2str(round((t08)*10)/10) ' sec)'])

%% Sort out indices according to their vert. precision and in elev. range 
% Create vector for all indices
ind_All=1:length(Elev);
% Create vector of indices for all points with VtPrec<0.1 (10 cm precision)
ind_VtPrcLsTh10cm=find(VtPrec<0.1);
ind_VtPrcLsTh05cm=find(VtPrec<0.05);
% Create vector of indices for all points within elevation range of -2 to 4
% (a.k.a. the "pits and spikes" problem)
ind_ElevInRng=find(Elev>=-30&Elev<=-20);
% ind_ElevInRng=find(Elev>=-2&Elev<=4);

% Create vector of indices for all points that satisfy both criteria (low 
% VtPrec. within Elev. range)
ind_Usable10cm=ind_VtPrcLsTh10cm(ismember(ind_VtPrcLsTh10cm,ind_ElevInRng)==1);
ind_Usable05cm=ind_VtPrcLsTh05cm(ismember(ind_VtPrcLsTh05cm,ind_ElevInRng)==1);

% Create variables containig only the "cleaned" (VtPrec and ElevRange) data
PtID_cl_10cm=PtID(ind_Usable10cm);
PtTime_cl_10cm=PtTime(ind_Usable10cm);
SATS_cl_10cm=SATS(ind_Usable10cm);
PDOP_cl_10cm=PDOP(ind_Usable10cm);
HDOP_cl_10cm=HDOP(ind_Usable10cm);
VDOP_cl_10cm=VDOP(ind_Usable10cm);
North_cl_10cm=North(ind_Usable10cm);
East_cl_10cm=East(ind_Usable10cm);
Elev_cl_10cm=Elev(ind_Usable10cm);
HzPrec_cl_10cm=HzPrec(ind_Usable10cm);
VtPrec_cl_10cm=VtPrec(ind_Usable10cm);

PtID_cl_05cm=PtID(ind_Usable05cm);
PtTime_cl_05cm=PtTime(ind_Usable05cm);
SATS_cl_05cm=SATS(ind_Usable05cm);
PDOP_cl_05cm=PDOP(ind_Usable05cm);
HDOP_cl_05cm=HDOP(ind_Usable05cm);
VDOP_cl_05cm=VDOP(ind_Usable05cm);
North_cl_05cm=North(ind_Usable05cm);
East_cl_05cm=East(ind_Usable05cm);
Elev_cl_05cm=Elev(ind_Usable05cm);
HzPrec_cl_05cm=HzPrec(ind_Usable05cm);
VtPrec_cl_05cm=VtPrec(ind_Usable05cm);

t09=toc;
disp([num2str(round((t09-t08)*10)/10) ' sec = cleaned data for vert. precis. and elev. range (total=' num2str(round((t09)*10)/10) ' sec)'])

%% Build boundary polygon for cleaned data
K_10cm=boundary(East_cl_10cm,North_cl_10cm,0.9);
K_05cm=boundary(East_cl_05cm,North_cl_05cm,0.9);
t10=toc; disp([num2str(round((t10-t09)*10)/10) ' sec = bounded data (total=' num2str(round((t10)*10)/10) ' sec)'])

%% Make plots of Elevation Vt. Precision as f(serial pt. number) 

figure(2)
subplot(2,1,1)
plot(ind_All,Elev,'r*'),hold on
plot(ind_All(ind_ElevInRng),Elev(ind_ElevInRng),'b*')
plot(ind_All(ind_Usable10cm),Elev(ind_Usable10cm),'g*')
plot(ind_All(ind_Usable05cm),Elev(ind_Usable05cm),'m.'),grid on
% set(gca,'YLim',[-2 4])
xlabel('Serial Point Number'),ylabel('Elevation (m)')
title([dateForTitles],'FontSize',14)
set(gca,'FontSize',14)

subplot(2,1,2)
plot(ind_All,100*VtPrec,'r*'),hold on
plot(ind_All(ind_VtPrcLsTh10cm),100*VtPrec(ind_VtPrcLsTh10cm),'b*')
plot(ind_All(ind_Usable10cm),100*VtPrec(ind_Usable10cm),'g*')
plot(ind_All(ind_Usable05cm),100*VtPrec(ind_Usable05cm),'m.'),grid on
set(gca,'YLim',[0 20])
xlabel('Serial Point Number'),ylabel('Vt. Precision (cm)')
set(gca,'FontSize',14)

%% Plot the spatial (map) data and boundary
figure(3)
set(gcf,'position',[920 80 900 1200])
hax1=axes;
plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'bo'),hold on
plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'rx','linewidth',3)
plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g.','linewidth',1)
title(['Cleaned Data and Polygon, ' dateForTitles])
xlabel('km East, UTM Zone 17R')
ylabel('km North, UTM Zone 17R')
grid on
axis equal

% set(gca,'YLim',[3160 3169],'XLim',[536.5 542.5])
set(gca,'FontSize',14)

% hax2=axes('position',[0.55 0.6 0.3 0.3]);
% plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'b*'),hold on
% plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'r','linewidth',3)
% plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
% plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g','linewidth',1)
% grid on
% set(gca,'YLim',[3168.48 3168.58],'XLim',[536.78 536.86])

% hax3=axes('position',[0.25 0.15 0.3 0.3]);
% plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'b*'),hold on
% plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'r','linewidth',3)
% plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
% plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g','linewidth',1)
% grid on
% set(gca,'YLim',[3160.26 3160.36],'XLim',[542.05 542.15])

t10=toc;
disp([num2str(round((t10-t09)*10)/10) ' sec = plotted data (total=' num2str(round((t10)*10)/10) ' sec)'])

%% Save the data
cmd=['save ' genl_path clean_dir 'CleanSurveyData_' date_str '.mat'];
eval(cmd)
t11=toc;
disp([num2str(round((t11-t10)*10)/10) ' sec = saved data (total=' num2str(round((t11)*10)/10) ' sec)'])

%% Print to pdf and png files
figure(2),set(gcf,'units','inches','PaperPosition',[0 0 6.5 6.5],'PaperSize',[6.5 6.5])  
% print('-dpdf',['/Users/pna/Desktop/KSC_ImportClean_20' date_str '.pdf'])
print('-dpng','-r600',[genl_path 'FigDumps/' loc_id 'DCS_20' date_str '.png'])
figure(3),set(gcf,'units','inches','PaperPosition',[0 0 6.5 9],'PaperSize',[6.5 9])  
% print('-dpdf',['/Users/pna/Desktop/KSC_ImportMap_20' date_str '.pdf'])
print('-dpng','-r600',[genl_path 'FigDumps/' loc_id 'MapQCpts_20' date_str '.png'])

t12=toc;
disp([num2str(round((t12-t11)*10)/10) ' sec = printed graphics (total=' num2str(round((t12)*10)/10) ' sec)'])

