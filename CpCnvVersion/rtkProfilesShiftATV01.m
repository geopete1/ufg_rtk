function [T]=rtkCpCnvShiftATVProfiles01(SurvDateStr,DuneX,DuneY)

load(['/Users/pna/Dropbox/Data/Data01_CpCnv/matDataProcessedDEMs/DEM_CpCnv_' SurvDateStr '.mat'])

hf1=figure('units','inches','position',[0.5 9 22 8]);
hf2=figure('units','inches','position',[23 9 11 8]);

for i=11:length(T)
    figure(hf1)
    subplot(1,2,1)
    plot(DuneX,DuneY),hold on
    plot(DuneX,DuneY,'k*'),grid on,axis equal
    box_x=[min(T(i).xi) min(T(i).xi) max(T(i).xi) max(T(i).xi) min(T(i).xi)];
    box_y=[min(T(i).yi) max(T(i).yi) max(T(i).yi) min(T(i).yi) min(T(i).yi)];
    plot(box_x,box_y,'r')
    xlabel('UTM Easting (m)','FontSize',14)
    ylabel('UTM Northing (m)','FontSize',14)
    set(gca,'FontSize',14)
    
    subplot(1,2,2)
    plot(T(i).xi,T(i).yi,'b.'),hold on
    plot(DuneX,DuneY,'linewidth',2),grid on,axis equal
    plot(DuneX(i),DuneY(i),'ko','linewidth',1,'MarkerfaceColor','r','MarkerSize',15)
    ri=find(isnan(T(i).zi)~=1);
    plot(T(i).xi(ri),T(i).yi(ri),'rp')
    plot(X,Y,'m.')
    plot(PX_n,PY_n,'g','linewidth',1.5),plot(PX_s,PY_s,'g','linewidth',1.5)

    xlabel('UTM Easting (m)','FontSize',14)
    ylabel('UTM Northing (m)','FontSize',14)
    title(['DSAS Transect ' num2str(i)])
    set(gca,'FontSize',14,...
        'XLim',[min(T(i).xi) max(T(i).xi)],'YLim',[min(T(i).yi) max(T(i).yi)])
    
    d2DptsDSAS=sqrt(((T(i).xi-DuneX(i)).^2) +((T(i).yi-DuneY(i)).^2));
    indDuneDSAS=find(d2DptsDSAS==min(d2DptsDSAS));
    DshiftDSAS=sqrt(((T(i).xi(indDuneDSAS)-T(i).xi(1))^2)+((T(i).yi(indDuneDSAS)-T(i).yi(1))^2));
    T(i).ddi=T(i).di-DshiftDSAS;

    figure(hf2)
    plot(T(i).di,T(i).zi,'--','linewidth',2),hold on
    plot(T(i).ddi,T(i).zi,'linewidth',2),grid on
    set(gca,'FontSize',14,'XLim',[-50 300],'YLim',[-1 2.5])
    xlabel('Cross-Shore Position w.r.t. Dune Crest (m)','FontSize',14)
    ylabel('Elevation (m)','FontSize',14)
    title(['DSAS Profile ' num2str(i)])
    
    pause(0.1)
    figure(hf1),clf
    figure(hf2),clf
end

close all

