function [Xg_n_rot,Yg_n_rot,Zg_n_rot,Xg_s_rot,Yg_s_rot,Zg_s_rot]=...
    rtkProcess01e_buildRasters(surveydate,X_n_rot,Y_n_rot,Z_n,X_s_rot,Y_s_rot,Z_s,...
    PX_n_rot,PY_n_rot,PX_s_rot,PY_s_rot)
%
% Function to build 1m x 1m rotated rasters of the north and south reaches
% of coast being analyzed.  Inputs include the surveydate string, the 
% coordinates of the rotated survey data and rotated bounding polygon(s).
%
% by pna at UF, Oct. 2010
% modified by pna at UF, Mar. 1, 2012
% updated by pna at UF, Aug. 19, 2016
%%
disp('Running function rtkProcess01e_buildRasters.m')

%% Set up the X and Y raster grids and interpolate elevations
dx=1; dy=1; 
% disp('Building grid for northern clip')
[Xg_n_rot,Yg_n_rot]=meshgrid(min(PX_n_rot):dx:max(PX_n_rot),min(PY_n_rot):dy:max(PY_n_rot));
Zg_n_rot=griddata(X_n_rot,Y_n_rot,Z_n,Xg_n_rot,Yg_n_rot);

% disp('Building grid for southern clip')
[Xg_s_rot,Yg_s_rot]=meshgrid(min(PX_s_rot):dx:max(PX_s_rot),min(PY_s_rot):dy:max(PY_s_rot));
Zg_s_rot=griddata(X_s_rot,Y_s_rot,Z_s,Xg_s_rot,Yg_s_rot);

%% Eliminate elevation data for points outside the clipped polygons
% disp('Eliminating points outside northern polygon')
IN=inpoly([Xg_n_rot(:) Yg_n_rot(:)],[PX_n_rot(:) PY_n_rot(:)]);
Zg_n_rot(~IN)=0./0;
% disp('Eliminating points outside southern polygon')
IN=inpoly([Xg_s_rot(:) Yg_s_rot(:)],[PX_s_rot(:) PY_s_rot(:)]);
Zg_s_rot(~IN)=0./0;
