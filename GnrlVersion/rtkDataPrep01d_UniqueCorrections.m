if strcmp(date_str,'170908')
    indFaultyAntHeights=find(AntHeight_r13>1.75);
    AntHtDiscrep=1.754-1.745;
    Elev_r13(indFaultyAntHeights)=Elev_r13(indFaultyAntHeights)+AntHtDiscrep;
end

if strcmp(date_str,'170913')
    indFaultyAntHeights=find(AntHeight_r13>1.99);
    AntHtDiscrep=2-1.588;
    Elev_r13(indFaultyAntHeights)=Elev_r13(indFaultyAntHeights)+AntHtDiscrep;
end
