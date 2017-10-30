function [X_n,Y_n,Z_n,X_s,Y_s,Z_s,X_n_rot,Y_n_rot,X_s_rot,Y_s_rot,...
    PX_n_rot,PY_n_rot,PX_s_rot,PY_s_rot,R_n,Rback_n,R_s,Rback_s]=...
    rtkProcess01d_rotateData...
    (surveydate,RefFeatDir,Y,X,Z,PX_n,PY_n,PX_s,PY_s,theta_opt_n,theta_opt_s)
%
% Function to rotate a series of rtk-obtained survey points as well as 
% their north and south bounding polygons.  Inputs include the surveydate 
% string, the coordinates of the bounding polygon(s), and the survey data 
% points themselves.
%
% by pna at UF, Oct. 2010
% modified by pna at UF, Mar. 1, 2012
% updated by pna at UF, Aug. 19, 2016
%%
disp('Running function rtkProcess01d_rotateData.m')

%% Load the regional boxes
load([RefFeatDir 'NrthBox_Mtnzs.mat']) 
load([RefFeatDir 'SthBox_Mtnzs.mat'])

%% Separate survey data in northern reach from those in southern reach
% disp('Separating survey data into northern & southern reaches')
IN_n=inpoly([X(:) Y(:)],[NrthBoxPolyMtnzs_x(:) NrthBoxPolyMtnzs_y(:)]);
IN_s=inpoly([X(:) Y(:)],[SthBoxPolyMtnzs_x(:) SthBoxPolyMtnzs_y(:)]);
X_n=X(IN_n); Y_n=Y(IN_n); Z_n=Z(IN_n);
X_s=X(IN_s); Y_s=Y(IN_s); Z_s=Z(IN_s);

%% Set up rotation (and back rotation) coeff. matrices for both reaches
theta_n=theta_opt_n;
theta_s=theta_opt_s;
R_n=[cosd(theta_n) sind(theta_n); -sind(theta_n) cosd(theta_n)];
Rback_n=[cosd(-theta_n) sind(-theta_n); -sind(-theta_n) cosd(-theta_n)];
R_s=[cosd(theta_s) sind(theta_s); -sind(theta_s) cosd(theta_s)];
Rback_s=[cosd(-theta_s) sind(-theta_s); -sind(-theta_s) cosd(-theta_s)];

%% Rotate the X and Y survey data points for northern and southern clippings
% disp('Rotating survey data for northern clip')
XY_n_rot=R_n*[X_n'; Y_n']; 
X_n_rot=XY_n_rot(1,:); 
Y_n_rot=XY_n_rot(2,:);
% disp('Rotating survey data for southern clip')
XY_s_rot=R_s*[X_s'; Y_s']; 
X_s_rot=XY_s_rot(1,:); 
Y_s_rot=XY_s_rot(2,:);

%% Rotate northern and southern polygons
PX_n=PX_n'; PY_n=PY_n'; PX_s=PX_s'; PY_s=PY_s';
% disp('Rotating northern polygon')
PXPY_n_rot=R_n*[PX_n; PY_n];
PX_n_rot=PXPY_n_rot(1,:);
PY_n_rot=PXPY_n_rot(2,:);
% disp('Rotating southern polygon')
PXPY_s_rot=R_s*[PX_s; PY_s];
PX_s_rot=PXPY_s_rot(1,:);
PY_s_rot=PXPY_s_rot(2,:);

