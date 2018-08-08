function [t,uGen,vol_err]=HydrographFit(tObs,uObs,tPeakObs,uPeak,time2peak,duration,ubase)
%create a hydrograph using peak-discharge, time to peak, duration, and gamma function

[rows,cols]=size(tObs);
vol=0;
for i=2:1:rows
    vol=vol+(tObs(i)-tObs(i-1))*0.5*(uObs(i)+uObs(i-1));   %integrate observed series
end
vol_meas=vol;

figure;
plot(tObs,uObs);

alpha_max=15;     %maximum gamma equation shape factor
ia=0;
uGen=[];
for a=1:1:alpha_max
    ia=ia+1;
    tlegend{ia+1}=num2str(a);
    t=linspace(0,duration,60);
    %reference for the follwing equation: Bastian Klein et al., 2009. Stochastic Generation of Hydrographs for the Flood Design of Dams
    Hg=uPeak*(t/time2peak).^a.*exp(a*(1-t/time2peak));
    
    Hg=Hg+ubase;
    t=t+(tPeakObs-time2peak);
    t=[0,t,t(end)+20,tObs(end)];
    Hg=[ubase,Hg,ubase,ubase];
    
    hold on;
    plot(t,Hg); 
    
    uGen=[uGen;Hg];
end

tlegend{1}='measured';
legend(tlegend);

vol_err=zeros(ia,1);
for i=1:1:ia
    vol=0;
    for k=2:1:63
        vol=vol+(t(k)-t(k-1))*0.5*(uGen(i,k)+uGen(i,k-1));
    end
   
    vol_err(i)=(vol-vol_meas)/vol_meas;
end
