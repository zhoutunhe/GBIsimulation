function [f1]=fresnel2d2(f0,dx0,dy0,z,lambda,equalRow)
if ~exist('equalRow','var')
    equalRow = 0;
end
[N M]=size(f0);k=2*pi/lambda;
u=zeros(1,M); 
v=zeros(N,1);
% u = fftshift((-M/2:M/2-1)/(M*dx0));
% v = fftshift((-N/2:N/2-1)/(N*dy0));
u = (-M/2:M/2-1)/(M*dx0);
v = (-N/2:N/2-1)/(N*dy0);
% du=1./(M*dx0); %frequency corresponds to x
% u=[0:M/2-1 -M/2:-1]*du;
% dv=1./(N*dy0); %frequency corresponds to y
% 
% v=[0:N/2-1 -N/2:-1]*dv;

if equalRow
    v=0;
end
[U V]=meshgrid(u,v);
H=exp(-1i*2*pi^2*(U.^2+V.^2)*z/k);
% figure, imagesc(u,v,angle(H)),title('phase factor of propagator')
% F0=fftshift(fft2(fftshift(f0)));
if equalRow
    f0=f0(ceil(N/2),:);
end
% f1=ifft2(fft2(f0).*H);
F0=ifftshift(fft2(fftshift(f0)));
f1=ifftshift(ifft2(ifftshift(F0.*H)));
if equalRow
    f1=ones(N,1)*f1;
end

