function plotFitting(dx0,dx,scanStep,Id,X1,X2,X3)
for i=round(size(Id,1)/2)
    for j=round(size(Id,2)/2)
        x=[0:.0206:2.06];
        xdata=dx0*round(dx/dx0*[0:scanStep]);
        ydata(1,:,1)=Id(i,j,:);
        figure,plot(xdata,ydata,'+');
        hold on,         plot(x,X1(i,j)*cos(2*pi*x/2.06+X2(i,j))+X3(i,j));
        legend('object image','object fitting','location','northwest')
        xlabel('G2 transverse shift x ({\mu}m)')
        ylabel('photon number')
    end
end




