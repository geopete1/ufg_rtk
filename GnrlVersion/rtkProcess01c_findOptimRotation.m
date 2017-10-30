function [theta_opt_n theta_opt_s theta Xrange_n Xrange_s]=...
    rtkProcess01c_findOptimRotation(RefFeatDir,PX_n,PY_n,PX_s,PY_s)
%
% Function to determine the optimum rotation angles for north and south
% reaches of coastal area being examined.
%
% by pna at UF, R/3/1/2012 - built from 2 year old code
% updated by pna at UF, Aug. 19, 2016
% updated by pna at home, Sept. 18, 2017
%%
disp('Running function rtkCpCnvProcess01c_findOptimRotation.m')

%% Load the regional boxes
load([RefFeatDir 'NrthBox_Mtnzs.mat']) 
load([RefFeatDir 'SthBox_Mtnzs.mat'])

figure('units','inches','position',[6 6 5 5])
plot(PX_n,PY_n,'b.'),hold on,grid on
plot(PX_s,PY_s,'g.')
PX_n=PX_n'; PY_n=PY_n'; PX_s=PX_s'; PY_s=PY_s';

theta=[0-45:1:45];
for i=1:length(theta)
    R=[cosd(theta(i)) sind(theta(i)); -sind(theta(i)) cosd(theta(i))];
    PXPY_n_rot=R*[PX_n; PY_n];
    PXPY_s_rot=R*[PX_s; PY_s];
    PX_n_rot=PXPY_n_rot(1,:);
    PY_n_rot=PXPY_n_rot(2,:);
    PX_s_rot=PXPY_s_rot(1,:);
    PY_s_rot=PXPY_s_rot(2,:);
    plot(PX_n_rot,PY_n_rot,'b.')
    plot(PX_s_rot,PY_s_rot,'g.')
    if rem(theta(i),5)==0
        text(PX_n_rot(1),PY_n_rot(1),[num2str(theta(i)) ' deg.'])
    end
    axis equal
    Xrange_n(i)=max(PX_n_rot)-min(PX_n_rot);
    Xrange_s(i)=max(PX_s_rot)-min(PX_s_rot);
    clear R PXPY_n_rot PX_n_rot PY_n_rot PXPY_s_rot PX_s_rot PY_s_rot
end

ind_min_n=find(Xrange_n==min(Xrange_n));
ind_min_s=find(Xrange_s==min(Xrange_s));
theta_opt_n=theta(ind_min_n);
theta_opt_s=theta(ind_min_s);

