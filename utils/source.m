function fsource=source(X,Y,w,h,gaussian,elliptical,square,sourceDist,detectorDist)
%gaussian: w-FWHMx, h-FWHMy
%elliptical: w-width, h-hight
%X, Y: matrix of coordinate in object plane
%not considering the angle

sourceGeometry =[]; %when it is not gaussian or elliptical
if gaussian
    sigmaX = num2str(w/(2*sqrt(log(2))));
    sigmaY = num2str(h/(2*sqrt(log(2))));
    sourceGeometry = inline(...
        ['exp(-((x/' sigmaX ').^2+(y/' sigmaY ').^2))'],'x','y');
    elseif elliptical 
        width = num2str(w);
        height=num2str(h);
            sourceGeometry = inline(...
        ['(x/' width ').^2+(y/' height ').^2<1'],'x','y');
elseif square
    width = num2str(w);
        height=num2str(h);
            sourceGeometry = inline(...
        ['abs(x/' width ')<1 & abs(y/' height ')<1'],'x','y');
end
fsource=ones(size(X)); %default value is just plane wave 1.

if ~isempty(sourceGeometry) 
    Xc = X-X(1,1+ceil(end/2)); %x-distance from origo
    Yc = Y-Y(1+ceil(end/2),1);
    fsource=sourceGeometry(Xc*(1+sourceDist/detectorDist),Yc...
        *(1+sourceDist/detectorDist));
end
fsource=fsource/sum(sum(fsource));
