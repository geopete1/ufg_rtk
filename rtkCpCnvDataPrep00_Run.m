close all,clear all
% sd={'09_05_06' '09_05_07' '09_05_24' '09_05_28' '09_06_06' '09_06_07' ...
%     '09_07_06' '09_07_07' '09_08_01' '09_08_02' '09_09_05' '09_10_05' ...
%     '09_11_06' '09_11_07' '09_12_01'};
sd={'09_05_06'};

for j=1:length(sd)
    disp(sprintf(['\n' 'Working on Survey ID ' sd{j}]))
    disp(sprintf(['\n' 'Running Import fcn...\n']))
    rtkCpCnvDataPrep01_Import(sd{j})
    disp(sprintf(['\n' 'Running DCS fcn...\n']))
    rtkCpCnvDataPrep02_DCS(sd{j})
end
