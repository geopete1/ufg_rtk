function [T]=rtkProcess01g_interpProfiles(RefFeatDir,Xg_n,Yg_n,Xg_s,Yg_s,Zg_n,Zg_s);

Fn= TriScatteredInterp(Xg_n(:),Yg_n(:),Zg_n(:));
Fs= TriScatteredInterp(Xg_s(:),Yg_s(:),Zg_s(:));

%%
disp('Running function rtkProcess01g_interpProfiles.m')

%% Bring in the pre-defined transects
load([RefFeatDir 'MtnzsTransects151.mat']);

for i=1:length(T_Mtnzs)
    T(i).xi=T_Mtnzs(i).xi;
    T(i).yi=T_Mtnzs(i).yi;
    T(i).di=T_Mtnzs(i).di;
    if i<111
        T(i).zi=Fn(T(i).xi,T(i).yi);
    else
        T(i).zi=Fs(T(i).xi,T(i).yi);
    end
end
%% Previous version - Kennedy Space Center
% load([RefFeatDir 'Transects.mat']) 
% for i=1:1011
%     T(i).xi=linspace(EndX(i),StartX(i),1000);
%     T(i).yi=linspace(EndY(i),StartY(i),1000);
%     T(i).di=[0; cumsum(sqrt((diff(T(i).xi).^2)+(diff(T(i).yi).^2)))'];
%     if i<796
%         T(i).zi=Fn(T(i).xi,T(i).yi);
%     else
%         T(i).zi=Fs(T(i).xi,T(i).yi);
%     end
% end
