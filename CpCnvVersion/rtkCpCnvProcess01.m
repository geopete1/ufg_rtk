%% dgpsCpCnvProcess01.m
%
% The main (trunk) code to produce DEMs from RTK-GPS data from KSC-CpCnv
% surveys. This code calls several other functions then conducts a bunch of
% plotting.
%
% By pna at UF Dec. 3, 2009
% Improved by pna at UF, Apr. 21, 2010
% Generalized in the van, Feb. 29, 2012
% Overhauled to jibe with new DataPrep files, Jun2 2016
%%
function rtkCpCnvProcess01(surveydate,datadir,RefFeatDir,PcsdDataDir)
% surveydate='110613'; res='05';
disp(surveydate)
tic
%% 1. Convert survey data variable names from DataPrep to Process
[Y X Z East_cl_10cm North_cl_10cm K_10cm]=...
    rtkCpCnvProcess01a_loadmat(datadir,surveydate);
toc
%% 2. Obtain Bounding Polygons and Break survey data into two regions
[PX_n,PY_n,PX_s,PY_s]=rtkCpCnvProcess01b_getPolygons(surveydate,...
    RefFeatDir,East_cl_10cm,North_cl_10cm,K_10cm);
toc
%% 3. Determine rotation angles for grid building
[theta_opt_n,theta_opt_s,theta,Xrange_n,Xrange_s]=...
    rtkCpCnvProcess01c_findOptimRotation(RefFeatDir,PX_n,PY_n,PX_s,PY_s);
toc
%% 4. Rotate survey data
[X_n,Y_n,Z_n,X_s,Y_s,Z_s,X_n_rot,Y_n_rot,X_s_rot,Y_s_rot,...
    PX_n_rot,PY_n_rot,PX_s_rot,PY_s_rot,R_n,Rback_n,R_s,Rback_s]=...
    rtkCpCnvProcess01d_rotateData(surveydate,RefFeatDir,Y,X,Z,PX_n,PY_n,...
    PX_s,PY_s,theta_opt_n,theta_opt_s);
toc
%% 5. Interpolate the rasters
[Xg_n_rot,Yg_n_rot,Zg_n_rot,Xg_s_rot,Yg_s_rot,Zg_s_rot]=...
    rtkCpCnvProcess01e_buildRasters(surveydate,X_n_rot,Y_n_rot,Z_n,...
    X_s_rot,Y_s_rot,Z_s,PX_n_rot,PY_n_rot,PX_s_rot,PY_s_rot);
toc
%% 6. Backrotate the rasters
[Xg_n,Yg_n,Xg_s,Yg_s,Zg_n,Zg_s]=rtkCpCnvProcess01f_backrotateRasters...
    (Rback_n,Rback_s,Xg_n_rot,Yg_n_rot,Xg_s_rot,Yg_s_rot,Zg_n_rot,Zg_s_rot);
toc
%% 7. Interpolate DSAS profiles from the rasters
[T]=rtkCpCnvProcess01g_interpProfiles(RefFeatDir,Xg_n,Yg_n,Xg_s,Yg_s,...
    Zg_n,Zg_s);
toc
%% 8. Save to .mat file
disp('Saving Processed DEM and Profiles')
save([PcsdDataDir 'DEM_CpCnv_20' surveydate '.mat'],'Xg_n','Yg_n',...
    'Zg_n','Xg_s','Yg_s','Zg_s','Y','X','Z','PX_n','PY_n','PX_s','PY_s','T')
toc
%% Make All Figures

%% Make Plots

%% MORE PLOTTING

% Figure 3: Results of Search for Optimal Angle of Rotation
figure('units','inches','position',[6 1 5 5])
plot(theta,Xrange_n,'b','linewidth',2),hold on
plot(theta,Xrange_s,'g','linewidth',2),grid on
text(theta_opt_n,4000,['Opt. North Rotation = ' num2str(theta_opt_n) ' deg.'])
text(theta_opt_s,2000,['Opt. South Rotation = ' num2str(theta_opt_s) ' deg.'])
xlabel('Rotation Angle (deg.)'),ylabel('Cross Shore Data Spread (m)')

% Figure 4: Data Point Locations from Northern Section - Distorted and Rotated
figure('units','inches','position',[11 6.5 4 6])
plot(X_n_rot,Y_n_rot,'b.'),hold on
title('Rotated, Northern Data')
xlabel('Cross-shore position, rotated coordinates (m)')
ylabel('Along-shore position, rotated coordinates (m)')

% Figure 5: Data Point Locations from Northern Section - Distorted and Rotated
figure('units','inches','position',[11 0.5 4 6])
plot(X_s_rot,Y_s_rot,'g.')
title('Rotated, Southern Data')
xlabel('Cross-shore position, rotated coordinates (m)')
ylabel('Along-shore position, rotated coordinates (m)')

% Figure 6: DEM from Northern Section - Distorted and Rotated
figure('units','inches','position',[15 6.5 4 6])
pcolor(Xg_n_rot,Yg_n_rot,Zg_n_rot)
title('Rotated, Northern Raster')
xlabel('Cross-shore position, rotated coordinates (m)')
ylabel('Along-shore position, rotated coordinates (m)')
shading flat

% Figure 7: DEM from Southern Section - Distorted and Rotated
figure('units','inches','position',[15 0.5 4 6])
pcolor(Xg_s_rot,Yg_s_rot,Zg_s_rot)
title('Rotated, Southern Raster')
xlabel('Cross-shore position, rotated coordinates (m)')
ylabel('Along-shore position, rotated coordinates (m)')
shading flat

% Figure 8: DEM from Northern Section - Undistorted and Backrotated
figure('units','inches','position',[19 6.5 4 6])
pcolor(Xg_n,Yg_n,Zg_n),shading interp,axis equal,hold on
title('DEM from Northern Section')
xlabel('UTM Easting (m)')
ylabel('UTM Northing (m)')
drawnow

% Figure 9: DEM from Southern Section - Undistorted and Backrotated
figure('units','inches','position',[19 0.5 4 6])
pcolor(Xg_s,Yg_s,Zg_s),shading interp,axis equal,hold on
title('DEM from Southern Section')
xlabel('UTM Easting (m)')
ylabel('UTM Northing (m)')
drawnow
