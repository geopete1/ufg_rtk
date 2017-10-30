function [Xg_n,Yg_n,Xg_s,Yg_s,Zg_n,Zg_s]=rtkProcess01f_backrotateRasters...
    (Rback_n,Rback_s,Xg_n_rot,Yg_n_rot,Xg_s_rot,Yg_s_rot,Zg_n_rot,Zg_s_rot);
%
% Function to build 1m x 1m rotated rasters of the north and south reaches
% of coast being examinedd.  Inputs include the surveydate string, the 
% coordinates of the rotated survey data and rotated bounding polygon(s).
%
% by pna at UF, Mar. 1, 2012
% documented by pna at UF, June 12, 2012
% updated by pna at UF, Aug. 19, 2016
%%
disp('Running function rtkProcess01f_backrotateRasters.m')
%%
XYg_n=Rback_n*[Xg_n_rot(:)'; Yg_n_rot(:)'];
Xg_n=reshape(XYg_n(1,:),length(Xg_n_rot(:,1)),length(Xg_n_rot(1,:)));
Yg_n=reshape(XYg_n(2,:),length(Yg_n_rot(:,1)),length(Yg_n_rot(1,:)));
Zg_n=Zg_n_rot;

XYg_s=Rback_s*[Xg_s_rot(:)'; Yg_s_rot(:)'];
Xg_s=reshape(XYg_s(1,:),length(Xg_s_rot(:,1)),length(Xg_s_rot(1,:)));
Yg_s=reshape(XYg_s(2,:),length(Yg_s_rot(:,1)),length(Yg_s_rot(1,:)));
Zg_s=Zg_s_rot;

