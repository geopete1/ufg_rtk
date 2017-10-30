%% rtkCpCnvDataPrep00_Run.m
%
%% Code Purpose
%
% This is the "run" script that enacts the various tasks of rtk-gps data
% preparation (hence, 'DataPrep' in the code title) for UF's 5 year monthly
% measurements of beach bathymetry at NASA-Kennedy Space Center (KSC)
% during the time period from May 2009 through May 2014.
%
% This script: (1) allows the user to identify the dates of the field surveys to
% prep for detailed analysis, (2) identifies the relevant paths and
% directories for inputs and outputs, and (3) runs a loop that calls two
% functions - one that imports the text data saving it to a number of
% variables in a .mat file, and one that performs some basic display of
% data collection statistics.
%
% Developed and documented by pna at UF during summer of 2016
%
%% Close and Clear
%
% Start wit a clean slate.
%
close all,clear all
%% Identify Survey Dates to be Imported, Saved, and DCS-ed
%
% Below, commented out, are some cell arrays containing strings of dates to
% be imported and prepped by the loop in this function.
% 
% sd={'09_05_06' '09_05_07' '09_05_24' '09_05_28' '09_06_06' '09_06_07' ...
%    '09_07_06' '09_07_07' '09_08_01' '09_08_02' '09_09_05' '09_10_05' ...
%    '09_11_06' '09_11_07' '09_12_01'};
 
% sd={'10_01_03' '10_01_31' '10_02_28' '10_05_01' '10_05_02' '10_05_27' ...
%    '10_07_25' '10_07_28' '10_07_31' '10_08_28' '10_10_02' '10_10_03' ...
%    '10_10_09' '10_10_24' '10_10_25' '10_11_20' '10_12_21'};
 
sd={'13_12_16' '14_01_17' '14_02_14' '14_03_17' '14_04_15'};

%% Identify Paths and Directories
%
% genl_path='/Volumes/ls-geo-adams/Geo-Adams-Share/Data/Data01_RTK/';
genl_path='/Users/pna/Dropbox/Data/Data01_CpCnv/';
raw_dir='RTK_Survey_ReOrg_CPB/';
clean_dir='RTK_Survey_Clean_PNA/';

%% Run the Loop
%
for j=1:length(sd)
    disp(sprintf(['\n' 'Working on Survey ID ' sd{j}]))
    disp(sprintf(['\n' 'Running Import fcn...\n']))
    rtkCpCnvDataPrep01_Import(sd{j},genl_path,raw_dir,clean_dir)
    disp(sprintf(['\n' 'Running DCS fcn...\n']))
    rtkCpCnvDataPrep02_DCS(sd{j},genl_path,raw_dir,clean_dir)
end
