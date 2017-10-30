function rtkDataPrep02_DCS(surveydatestr,genl_path,raw_dir,clean_dir)
% clear all
% close all
tic

%% If running as a script, set the survey date
% surveydatestr='09_06_06';

%% Set the date and path
% date_str='090606';
date_str=[surveydatestr(1:2) surveydatestr(4:5) surveydatestr(7:8)];
dateForTitles=datestr(datetime(date_str,'InputFormat','yyMMdd'),'mmm-dd-yyyy');
loc_id='mtnzs_n_';

%% Load the Cleaned Data
load([genl_path clean_dir 'CleanSurveyData_' date_str '.mat'])
t01=toc;
disp([num2str(round(t01*10)/10) ' sec = .mat file loaded'])

%% Convert the variable names from the rtkDataPrep01_Import.m code to current
% for i=1:length(PtID),ptid(i)=str2num(PtID{i});,end, ptid=ptid';
Y=North; X=East; Z=Elev; Z_10cm=Elev_cl_10cm; Z_05cm=Elev_cl_05cm;
HzPrec=HzPrec; HzPrec_10cm=HzPrec_cl_10cm; HzPrec_05cm=HzPrec_cl_05cm;
VtPrec=VtPrec; VtPrec_10cm=VtPrec_cl_10cm; VtPrec_05cm=VtPrec_cl_05cm;
t02=toc; disp([num2str(round((t02-t01)*10)/10) ' sec = variable names converted ' '(total=' num2str(round((t02)*10)/10) ' sec)'])

%% Convert the datetime format from the dgpsCpCnvDataPrep.m code to serial date
olddate = datetime(date_str,'InputFormat','yyMMdd');
tod = timeofday(PtTime); tod_10cm = timeofday(PtTime_cl_10cm); tod_05cm = timeofday(PtTime_cl_05cm); 
newt = olddate + tod; newt_10cm = olddate + tod_10cm; newt_05cm = olddate + tod_05cm;
dn=datenum(newt); dn_10cm=datenum(newt_10cm); dn_05cm=datenum(newt_05cm);
clear PtTime PtTime_10cm PtTime_05cm
t03=toc;
disp([num2str(round((t03-t02)*10)/10) ' sec = time formats converted '...
    '(total=' num2str(round((t03)*10)/10) ' sec)'])

%% Compute the Data Collection Rate

edges=[min(dn):1./(24*60):max(dn)];
n=histc(dn,edges); n_10cm=histc(dn_10cm,edges); n_05cm=histc(dn_05cm,edges);

%% Save the converted variables names (if desired)
% save(['/Users/pna/Desktop/DataCollectStats_20' date_str '.mat'])
% toc,disp('File Saved')

%% Bring on the Plotting

figure

subplot(3,1,1),hold on
plot(edges,n,'r')
plot(edges,n_05cm,'g')
plot(edges,n_10cm,'b')
grid on
srv_time_start=5;
srv_time_end=13;
set(gca,'box','on','XLim',[floor(dn(1))+(srv_time_start/24) floor(dn(1))+(srv_time_end/24)],...
    'YLim',[0 300],'XTick',[floor(dn(1))+(srv_time_start/24):1/24:floor(dn(1))+(srv_time_end/24)])
datetick('x','keepticks','keeplimits')
title([loc_id ' Beach Survey, ' dateForTitles])
text(floor(dn(1))+(srv_time_start/24),250,['# Pts. Collected = ' num2str(length(Z))])
text(floor(dn(1))+(srv_time_start/24),220,['# Pts. w/ V.P. < 10cm = ' num2str(length(Z_10cm)) ' ('  num2str(round(10*100*length(Z_10cm)/length(Z))/10) '%)'])
text(floor(dn(1))+(srv_time_start/24),190,['# Pts. w/ V.P. < 5 cm = ' num2str(length(Z_05cm)) ' ('  num2str(round(10*100*length(Z_05cm)/length(Z))/10) '%)'])
xlabel('Time of Day')
ylabel('Data Collection Rate (# pts/min)')
set(gca,'FontSize',14)

subplot(3,3,4)
% hist(100*HzPrec,100*[0:0.001:0.15])
hist(HzPrec)
grid on
% set(gca,'XLim',100*[0 0.15],'YLim',[0 3500])
xlabel('Horiz. Precision (cm)')
ylabel('Num. Data Points per 1 mm bin')
set(gca,'FontSize',14)

subplot(3,3,5)
hist(100*VtPrec,100*[0:0.001:0.15]),hold on
plot([5 5],[0 3500],'g--','linewidth',2)
plot([10 10],[0 3500],'b--','linewidth',2)
grid on
set(gca,'XLim',100*[0 0.15],'YLim',[0 3500])
xlabel('Vert. Precision (cm)')
set(gca,'FontSize',14)

subplot(3,3,6)
loglog(100*HzPrec,100*VtPrec,'r.'),hold on
loglog(100*HzPrec_10cm,100*VtPrec_10cm,'b.')
loglog(100*HzPrec_05cm,100*VtPrec_05cm,'g.')
set(gca,'XLim',[1e-1 1e3],'YLim',[1e-1 1e3])
set(gca,'XTick',[1e-1 1e0 1e1 1e2 1e3],'YTick',[1e-1 1e0 1e1 1e2 1e3])
set(gca,'YaxisLocation','right')
grid on
xlabel('Hz. Precision (cm)'),ylabel('Vt. Precision (cm)')
set(gca,'FontSize',14)

subplot(3,1,3),hold on
plot(dn,PDOP,'r.')
plot(dn,SATS,'g.')
grid on
set(gca,'box','on','XLim',[floor(dn(1))+(srv_time_start/24) floor(dn(1))+(srv_time_end/24)],...
    'YLim',[0 12],'XTick',[floor(dn(1))+(srv_time_start/24):1/24:floor(dn(1))+(srv_time_end/24)])
xlabel('Time of Day')
ylabel('PDOP (red), # Satellites (green)')
datetick('x','keepticks','keeplimits')
set(gca,'FontSize',14)

t04=toc;
disp([num2str(round((t04-t03)*10)/10) ' sec = plots plotted '...
    '(total=' num2str(round((t04)*10)/10) ' sec)'])

%% Print to pdf and png files
set(gcf,'PaperPosition',[0 0 6.5 9],'PaperSize',[6.5 9])  
% print('-dpdf',['/Users/pna/Desktop/KSC_DCS_20' date_str '.pdf'])
print('-dpng','-r600',[genl_path 'FigDumps/' loc_id 'DCS_20' date_str '.png'])

t05=toc;
disp([num2str(round((t05-t04)*10)/10) ' sec = plots printed to graphics files '...
    '(total=' num2str(round((t05)*10)/10) ' sec)'])

