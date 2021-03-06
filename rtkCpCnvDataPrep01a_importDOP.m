function [PtID,PtTime,NumSats_DOP,PDOP_DOP,HDOP_DOP,VDOP_DOP] = ...
    rtkCpCnvDataPrep01a_importDOP(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [VARNAME1,VARNAME2,VARNAME3,VARNAME4,VARNAME5,VARNAME6] =
%   IMPORTFILE(FILENAME) Reads data from text file FILENAME for the default
%   selection.
%
%   [VARNAME1,VARNAME2,VARNAME3,VARNAME4,VARNAME5,VARNAME6] =
%   IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [VarName1,VarName2,VarName3,VarName4,VarName5,VarName6] = importfile('cpcnv_120107_r13_DOP.txt',1, 31468);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2016/05/12 11:10:53

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: datetimes (%{HH:mm:ss}D)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%{HH:mm:ss}D%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
PtID = dataArray{:, 1};
PtTime = dataArray{:, 2};
NumSats_DOP = dataArray{:, 3};
PDOP_DOP = dataArray{:, 4};
HDOP_DOP = dataArray{:, 5};
VDOP_DOP = dataArray{:, 6};

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% VarName2=datenum(VarName2);


