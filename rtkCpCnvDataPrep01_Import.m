function rtkCpCnvDataPrep01_Import(surveydatestr)
% clear all
close all
tic

%% If running as a script, set the survey date
% surveydatestr='09_06_06';

date_str=[surveydatestr(1:2) surveydatestr(4:5) surveydatestr(7:8)];
genl_path='/Volumes/Adams-LAB/Data/Data01_RTK/RTK_Survey_Raw_CPB/';
dateForTitles=datestr(datetime(date_str,'InputFormat','yyMMdd'),'mmm-dd-yyyy');

% Define the path to the DOP and PTS files
path_r13=[genl_path surveydatestr '/25413/'];
path_r64=[genl_path surveydatestr '/25664/'];

% Construct the full filename strings for the DOP files
filename_r13_DOP=[path_r13 'cpcnv_' date_str '_r13_DOP.txt'];
filename_r64_DOP=[path_r64 'cpcnv_' date_str '_r64_DOP.txt'];

% Construct the full filename strings for the PTS files
filename_r13_PTS=[path_r13 'cpcnv_' date_str '_r13_Pts.txt'];
filename_r64_PTS=[path_r64 'cpcnv_' date_str '_r64_Pts.txt'];

% Import the DOP files for both rovers
[PtID_r13,PtTime_r13,NumSats_DOP_r13,PDOP_DOP_r13,HDOP_DOP_r13,VDOP_DOP_r13]=...
    rtkCpCnvDataPrep01a_importDOP(filename_r13_DOP);
[PtID_r64,PtTime_r64,NumSats_DOP_r64,PDOP_DOP_r64,HDOP_DOP_r64,VDOP_DOP_r64]=...
    rtkCpCnvDataPrep01a_importDOP(filename_r64_DOP);
t01=toc;
disp([num2str(round(t01*10)/10) ' sec = imported DOP'])

% Import the PTS files for both rovers
[Point_r13,North_r13,East_r13,Elev_r13,HzPrec_r13,VtPrec_r13,PDOP_PTS_r13,SATS_PTS_r13]=...
    rtkCpCnvDataPrep01b_importPTS(filename_r13_PTS);
t02=toc;
disp([num2str(round((t02-t01)*10)/10) ' sec = imported r13 PTS (total=' num2str(round((t02)*10)/10) ' sec)'])

[Point_r64,North_r64,East_r64,Elev_r64,HzPrec_r64,VtPrec_r64,PDOP_PTS_r64,SATS_PTS_r64]=...
    rtkCpCnvDataPrep01b_importPTS(filename_r64_PTS);
t03=toc;
disp([num2str(round((t03-t02)*10)/10) ' sec = imported r64 PTS (total=' num2str(round((t03)*10)/10) ' sec)'])

% Repair the Variables from the PTS file imports (to remove base station)
BaseStnName=Point_r13(1);
North_r13=North_r13(2:end); East_r13=East_r13(2:end); Elev_r13=Elev_r13(2:end);
HzPrec_r13=HzPrec_r13(2:end); VtPrec_r13=VtPrec_r13(2:end);
PDOP_PTS_r13=PDOP_PTS_r13(2:end); SATS_PTS_r13=SATS_PTS_r13(2:end);
t04=toc;
disp([num2str(round((t04-t03)*10)/10) ' sec = corrected r13 PTS (total=' num2str(round((t04)*10)/10) ' sec)'])

North_r64=North_r64(2:end); East_r64=East_r64(2:end); Elev_r64=Elev_r64(2:end);
HzPrec_r64=HzPrec_r64(2:end); VtPrec_r64=VtPrec_r64(2:end);
PDOP_PTS_r64=PDOP_PTS_r64(2:end); SATS_PTS_r64=SATS_PTS_r64(2:end);
t05=toc;
disp([num2str(round((t05-t04)*10)/10) ' sec = corrected r64 PTS (total=' num2str(round((t05)*10)/10) ' sec)'])

% Merge data from both rovers into a single set of variables to be cleaned
PtID=[PtID_r13; PtID_r64];
PtTime=[PtTime_r13; PtTime_r64];
NumSats=[NumSats_DOP_r13; NumSats_DOP_r64];
PDOP=[PDOP_DOP_r13; PDOP_DOP_r64];
HDOP=[HDOP_DOP_r13; HDOP_DOP_r64];
VDOP=[VDOP_DOP_r13; VDOP_DOP_r64];
North=[North_r13; North_r64];
East=[East_r13; East_r64];
Elev=[Elev_r13; Elev_r64];
HzPrec=[HzPrec_r13; HzPrec_r64];
VtPrec=[VtPrec_r13; VtPrec_r64];
t06=toc;
disp([num2str(round((t06-t05)*10)/10) ' sec = merged data (total=' num2str(round((t06)*10)/10) ' sec)'])

% Create vector for all indices
ind_All=1:length(Elev);
% Create vector of indices for all points with VtPrec<0.1 (10 cm precision)
ind_VtPrcLsTh10cm=find(VtPrec<0.1);
ind_VtPrcLsTh05cm=find(VtPrec<0.05);
% Create vector of indices for all points within elevation range of -2 to 4
% (a.k.a. the "pits and spikes" problem)
ind_ElevInRng=find(Elev>=-2&Elev<=4);
% Create vector of indices for all points that satisfy both criteria (low 
% VtPrec. within Elev. range)
ind_Usable10cm=ind_VtPrcLsTh10cm(ismember(ind_VtPrcLsTh10cm,ind_ElevInRng)==1);
ind_Usable05cm=ind_VtPrcLsTh05cm(ismember(ind_VtPrcLsTh05cm,ind_ElevInRng)==1);

% Create variables containig only the "cleaned" (VtPrec and ElevRange) data
PtID_cl_10cm=PtID(ind_Usable10cm);
PtTime_cl_10cm=PtTime(ind_Usable10cm);
NumSats_cl_10cm=NumSats(ind_Usable10cm);
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
NumSats_cl_05cm=NumSats(ind_Usable05cm);
PDOP_cl_05cm=PDOP(ind_Usable05cm);
HDOP_cl_05cm=HDOP(ind_Usable05cm);
VDOP_cl_05cm=VDOP(ind_Usable05cm);
North_cl_05cm=North(ind_Usable05cm);
East_cl_05cm=East(ind_Usable05cm);
Elev_cl_05cm=Elev(ind_Usable05cm);
HzPrec_cl_05cm=HzPrec(ind_Usable05cm);
VtPrec_cl_05cm=VtPrec(ind_Usable05cm);

t07=toc;
disp([num2str(round((t07-t06)*10)/10) ' sec = cleaned data (total=' num2str(round((t07)*10)/10) ' sec)'])

% Build boundary polygon for cleaned data
K_10cm=boundary(East_cl_10cm,North_cl_10cm,0.9);
K_05cm=boundary(East_cl_05cm,North_cl_05cm,0.9);
t08=toc;
disp([num2str(round((t08-t07)*10)/10) ' sec = bounded data (total=' num2str(round((t08)*10)/10) ' sec)'])

%% Make plots of Elevation Vt. Precision as f(serial pt. number) 
figure(1)
subplot(2,1,1)
plot(ind_All,Elev,'r*'),hold on
plot(ind_All(ind_ElevInRng),Elev(ind_ElevInRng),'b*')
plot(ind_All(ind_Usable10cm),Elev(ind_Usable10cm),'g*')
plot(ind_All(ind_Usable05cm),Elev(ind_Usable05cm),'m.'),grid on
set(gca,'YLim',[-2 4])
xlabel('Serial Point Number'),ylabel('Elevation (m)')
title([dateForTitles])

subplot(2,1,2)
plot(ind_All,100*VtPrec,'r*'),hold on
plot(ind_All(ind_VtPrcLsTh10cm),100*VtPrec(ind_VtPrcLsTh10cm),'b*')
plot(ind_All(ind_Usable10cm),100*VtPrec(ind_Usable10cm),'g*')
plot(ind_All(ind_Usable05cm),100*VtPrec(ind_Usable05cm),'m.'),grid on
set(gca,'YLim',[0 20])
xlabel('Serial Point Number'),ylabel('Vt. Precision (cm)')

%% Plot the spatial (map) data and boundary
figure(2)
set(gcf,'position',[920 80 900 1200])
hax1=axes;
plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'b*'),hold on
plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'r','linewidth',3)
plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g','linewidth',1)
title(['Cleaned Data and Polygon, ' dateForTitles])
xlabel('km East, UTM Zone 17R')
ylabel('km North, UTM Zone 17R')
grid on
axis equal
set(gca,'YLim',[3160 3169],'XLim',[536.5 542.5])

hax2=axes('position',[0.55 0.6 0.3 0.3]);
plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'b*'),hold on
plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'r','linewidth',3)
plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g','linewidth',1)
grid on
set(gca,'YLim',[3168.48 3168.58],'XLim',[536.78 536.86])

hax3=axes('position',[0.25 0.15 0.3 0.3]);
plot(East_cl_10cm/1e3,North_cl_10cm/1e3,'b*'),hold on
plot(East_cl_10cm(K_10cm)/1e3,North_cl_10cm(K_10cm)/1e3,'r','linewidth',3)
plot(East_cl_05cm/1e3,North_cl_05cm/1e3,'c.'),hold on
plot(East_cl_05cm(K_05cm)/1e3,North_cl_05cm(K_05cm)/1e3,'g','linewidth',1)
grid on
set(gca,'YLim',[3160.26 3160.36],'XLim',[542.05 542.15])

t09=toc;
disp([num2str(round((t09-t08)*10)/10) ' sec = plotted data (total=' num2str(round((t09)*10)/10) ' sec)'])

%% Save the data
genl_path='/Volumes/Adams-LAB/Data/Data01_RTK/RTK_Survey_Clean_PNA/';
cmd=['save ' genl_path 'CleanSurveyData_' date_str '.mat'];
eval(cmd)
t10=toc;
disp([num2str(round((t10-t09)*10)/10) ' sec = saved data (total=' num2str(round((t10)*10)/10) ' sec)'])

%% Print to pdf and png files
figure(1),set(gcf,'units','inches','PaperPosition',[0 0 6.5 6.5],'PaperSize',[6.5 6.5])  
% print('-dpdf',['/Users/pna/Desktop/KSC_ImportClean_20' date_str '.pdf'])
print('-dpng','-r600',['/Users/pna/Desktop/KSC_ImportClean_20' date_str '.png'])
figure(2),set(gcf,'units','inches','PaperPosition',[0 0 6.5 9],'PaperSize',[6.5 9])  
% print('-dpdf',['/Users/pna/Desktop/KSC_ImportMap_20' date_str '.pdf'])
print('-dpng','-r600',['/Users/pna/Desktop/KSC_ImportMap_20' date_str '.png'])

t11=toc;
disp([num2str(round((t11-t10)*10)/10) ' sec = printed graphics (total=' num2str(round((t11)*10)/10) ' sec)'])

