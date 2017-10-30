%% dgpsMtnzsMakeSurveyDatesArray.m
% Code to build a cell array and a vector of survey dates.
% 
% by pna at UF, Sept. 2014
% updated for Matanzas by pna at UF, Sept. 2017
%%
close all,clearvars
%% Identify the indices of the "regular" surveys, not "rapid response"
ind_RegSur=[];
%% Populate the cell array of survey dates strings manually
% These are entered as 6-character strings to make fit in with our file
% naming convention.
surveydate{1}='170908'; surveydate{2}='170913'; surveydate{3}='170926'; 
surveydate{4}='171019'; 
%% Rename variable for 6-digit surveydate to srvdts_6dig_str
srvdts_6dig_str=surveydate;
%% Convert the cell array survey dates string to a vector of datenums
for i=1:length(surveydate)
    srvdts_dn_num(i)=datenum(['20' surveydate{i}(1:2) '-' ...
        surveydate{i}(3:4) '-' surveydate{i}(5:6)]);
%     dn_surveydates(i)=datenum(['20' surveydate{i}(1:2) '-' ...
%         surveydate{i}(3:4) '-' surveydate{i}(5:6)]);
end
%% Convert vector of datenums to a cell array of 'calendar date' strings 
for i=1:length(surveydate)
    srvdts_cal_str{i}=datestr(srvdts_dn_num(i));
%     cal_surveydates{i}=datestr(dn_surveydates(i));
end
%% Save output to .mat file
OutputDir='/Users/pna/Dropbox/SharedFolders/Shared_Matanzas_HurricaneIrma/Data_Reference/';
OutputDir2='/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/Data_Reference/';
save([OutputDir 'Mtnzs_SurvDates.mat'],'ind_RegSur',...
    'srvdts_6dig_str','srvdts_dn_num','srvdts_cal_str')
save([OutputDir2 'Mtnzs_SurvDates.mat'],'ind_RegSur',...
    'srvdts_6dig_str','srvdts_dn_num','srvdts_cal_str')