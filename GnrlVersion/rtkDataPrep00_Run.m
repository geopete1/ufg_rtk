%% rtkDataPrep00_Run.m
%
%% Code Purpose
%
% This is the "run" script that enacts the various tasks of rtk-gps data
% preparation (hence, 'DataPrep' in the code title) for UF's measurements 
% of beach/dune topography at any of a number of field sites using our
% Trimble 5800 equipment.
%
% This script: (1) allows the user to identify the dates of the surveys to
% prep for detailed analysis, (2) identifies the relevant paths and
% directories for inputs and outputs, and (3) runs a loop that calls two
% functions - one that imports the text data saving it to a number of
% variables in a .mat file, and one that performs some basic display of
% data collection statistics.
%
% Developed and documented by pna at UF during summer of 2016 and
% generalized during Sept. 2017
%
%% Close and Clear
%
% Start wit a clean slate.
%
close all,clear all
warning off
%% Identify Survey Dates to be Imported, Saved, and DCS-ed
%
% Below, commented out, are some cell arrays containing strings of dates to
% be imported and prepped by the loop in this function.
% 
% sd={'13_12_16' '14_01_17' '14_02_14' '14_03_17' '14_04_15'};
% sd={'17_09_08' '17_09_13' '17_09_26'};
sd={'17_10_19'};

%% Identify Paths and Directories
%
% genl_path='/Volumes/ls-geo-adams/Geo-Adams-Share/Data/Data01_RTK/';
% genl_path='/Users/pna/Dropbox/Data/Data01_CpCnv/';
BaseDir='/Users/pna/Dropbox/SharedFolders/Shared_Matanzas_HurricaneIrma/';
genl_path='/Users/pna/Dropbox/Data/Data01_RTK/Mtnzs/';
raw_dir='RTK_Survey_02_Raw_txt/';
clean_dir='RTK_Survey_03_Clean_mat/';
RefFeatDir=[BaseDir 'Data_Reference/'];

%% Run the Loop
%
for j=1:length(sd)
    disp(sprintf(['\n' 'Working on Survey ID ' sd{j}]))
    disp(sprintf(['\n' 'Running Import fcn...\n']))
    rtkDataPrep01_Import(sd{j},genl_path,raw_dir,clean_dir)
    disp(sprintf(['\n' 'Running DCS fcn...\n']))
    rtkDataPrep02_DCS(sd{j},genl_path,raw_dir,clean_dir)
end
