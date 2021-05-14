 function [Id,xd,yd,npixelx]=detector2(X,pixel,I2,dx0,dy0)
%there seems a limit of the last cell matrix, so the npoint can't take some value
%Id=intensity of detector
%N=length(f0)
%pixel=size of one pixel
%I2=intensity after grating 2

npointx=floor(pixel/dx0);%npoint=number of points / pixel
npointy=floor(pixel/dy0);%npoint=number of points / pixel
npixelx=floor(size(X,2)/npointx);
%npixel = number of pixels in the detector
npixely=floor(size(X,1)/npointy);
L=zeros(1,npixely+1);
L(:)=npointy;
ny=npointy*npixely;
L(npixely+1)=size(X,1)-ny;
M=zeros(1,npixelx+1);
M(:)=npointx;
M(1)=M(1)-ceil((-size(X,2)+npointx*npixelx+npointx)/2);
M(npixelx+1)=size(X,2)-(npixelx-1)*npointx-M(1);
C=mat2cell(I2,L,M); %divide the intensity into L*M number of pixels
Id=zeros(npixely,npixelx);
for i=1:npixely
    for j=1:npixelx+1
        Id(i,j)=mean2(C{i,j}); %average the value of each pixel     
    end
end

xd=[.5:npixelx+1-.5]*pixel-(npixelx+1)*pixel/2;
yd=[.5:npixely-.5]*pixel-size(X,1)*dy0/2;

        