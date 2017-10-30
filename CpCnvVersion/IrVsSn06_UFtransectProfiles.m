close all, clearvars

BPS_data_dir='/Users/pna/Dropbox/Data/Data01_CpCnv/matDataBackPackSurveys/';
% ds='090906';
ds='090707';
load([BPS_data_dir 'BPS_CpCnv_' ds '.mat'])
n=N_UTM_N83m_Y;
e=E_UTM_N83m_X;
z=NADV88_m;
d=sqrt((diff(e).^2)+(diff(n).^2));
di=[0; cumsum(d)];

figure
subplot(2,1,1),plot(diff(e),'+'),grid on
ylabel({'Diff. Adjacent';'Easting Values (m)'} ) 
subplot(2,1,2),plot(diff(n),'+'),grid on
xlabel(['Index of Data Point in UF Transect Data Set' ds]) 
ylabel({'Diff. Adjacent';'Northing Values (m)'}) 
% Next, identify and save the transect break indices
brks=find(abs(diff(n))>50);
num_UF_tsects=length(brks)+1;
UFTid={'010','020','030','035','040','050','060','070','080','090','100','110','120'};
% Initialize the profile beginning index
pr_beg_ind=1;
% Loop through the profiles and
% record xi, yi, zi, di, and id fields for each transect into the T_BPS
% structure
for i=1:num_UF_tsects
    if i==num_UF_tsects,
        T_BPS(i).xi=e(pr_beg_ind:end);
        T_BPS(i).yi=n(pr_beg_ind:end);
        T_BPS(i).zi=z(pr_beg_ind:end);
    else
        T_BPS(i).xi=e(pr_beg_ind:brks(i));
        T_BPS(i).yi=n(pr_beg_ind:brks(i));
        T_BPS(i).zi=z(pr_beg_ind:brks(i));
        % increment to the index that marks the start of the next transect
        pr_beg_ind=brks(i)+1;
    end
% Compute cumulative distance along transect
    T_BPS(i).di=[0; cumsum(sqrt(((diff(T_BPS(i).xi)).^2)+((diff(T_BPS(i).yi)).^2)))];    
    % Record the transect Olson transect id string
    T_BPS(i).id=['T' UFTid{i}];
    % Create placeholders for cross shore position with respect to dune
    T_BPS(i).ddi=T_BPS(i).di;
end

figure
plot(e,n,'b.')
hold on
axis equal
grid on

for i=1:length(T_BPS)
    plot(T_BPS(i).xi(1),T_BPS(i).yi(1),'ro','MarkerSize',10)
    plot(T_BPS(i).xi(end),T_BPS(i).yi(end),'ro','MarkerSize',10)
    Out(i,:)=[T_BPS(i).xi(1) T_BPS(i).yi(1) T_BPS(i).xi(end) T_BPS(i).yi(end)];
end
    % figure(3)
% plot(di,z,'+')
figure
set(gcf,'units','inches','position',[11 1 11 17])
for i=1:6
    subplot(6,1,i)
    plot(T_BPS(i).di,T_BPS(i).zi,'linewidth',2)
    title(['UF Transect ' T_BPS(i).id])
    grid on
end

figure
set(gcf,'units','inches','position',[22 1 11 17])
for i=1:6
    subplot(6,1,i)
    plot(T_BPS(i+6).di,T_BPS(i+6).zi,'linewidth',2)
    title(['UF Transect ' T_BPS(i+6).id])
    grid on
end