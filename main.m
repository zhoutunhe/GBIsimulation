% Main file to simulate GBI
clc 
% clear all
% addpath('W:\MATLAB-filer\XRaySimulator')
matlab.desktop.editor.getActiveFilename
cd(fileparts(matlab.desktop.editor.getActiveFilename))

%% ON/OFF settings
useObject=1;        % =1 if there is an object
oneEnergy=0;        % =1 if monochromatic
useGrating1=1;
usesourcegeo=true;  % =1 if not point source.
sourceGrating=false;
useGrating2=1;
poissonNoise=0;     % =1 to add poisson noise
gaussianNoise=0;    % to add white gaussian noise
useNPS=1;           % to add non-white gaussian noise
realDetector=1; % real detector includes psf, QE etc corresponding to photonic science detector
adjustVisibility = 1;
equalRow=1; % =1 if every row is the same (the object is 1D)

%% Source parameters
sourceParameters  % change spot size, energy or spectrum in this file

%% Grating parameters
p1 = 4.12e-6; %the period of G1 (m).
w1 = p1/2;    %The width is half of the period.
p2 = p1/2;    %The period of G2 is half of p1 (at G1 plane).
w2 = p2/2;    %Duty cycle 1:1.
scanStep = 5;

%% Distance settings
l = .903;                    %source-G1 distance (m)
zeff = 3*p1^2/8/Lambdamiddle; %[m] 3th talbot distance, effective distance.
z = l*zeff/(l-zeff);          %[m] Real distance. 0.1495 m in experiment. Here calculated as 0.1496 m.
Dis_s_d = 1.089;             %[m] source to detector distance
M = Dis_s_d/l;               %magnification, from G1 to detector.
Dis_s_o = 0.874;             %[m] source to object distance

%% Object parameters
objectParameters   % change object settings in this file

%% detector parameters
detectorParameters  % pixel size, quantum efficiency etc can be changed inside
if useNPS
    NPS = inline('0.036156 + 0.61447*exp(-(f/11516.9196).^2) + 0.44444*exp(-(f/23663.0502).^2)','f');   %from XRaySimulator
    readoutNoise = 0.82;    
end
%% Simulation preparation
exposureTime = 20000;    %[s]. per scan

xmax=20*detectorResolution;    % define FOV at G1 plane 
xmin=-xmax;             
ymax=20*detectorResolution; 
ymin=-ymax;

dx0=.206e-6;    %intersample distance
dy0=detectorResolution;
Nx=ceil((xmax-xmin)/dx0);
Ny=ceil((ymax-ymin)/dy0);
x0=[-Nx/2+.5:Nx/2-.5]*dx0;
y0=[ymin/dy0+.5:ymax/dy0-.5]*dy0;
[X,Y]=meshgrid(x0,y0);

%% Propagation
propagation

%% figures

figure(10),clf,
subplot(3,2,1),colormap gray,imagesc(xd,yd,Abs)  ,  colorbar, title('Absorption'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,3),colormap gray,imagesc(xd,yd,Dpc)  , colorbar, title('Differential phase shift'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,5),colormap gray,imagesc(xd,yd,Dci)  , colorbar, title('Amplitude'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,2),plot(xd,Abs(round(end/2),:));
subplot(3,2,4),plot(xd,Dpc(round(end/2),:));
subplot(3,2,6),plot(xd,Dci(round(end/2),:));
figure(11),clf,
subplot(3,2,1),colormap gray,imagesc(xd,yd,Abs0)  ,  colorbar, title('Absorption (no noise)'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,3),colormap gray,imagesc(xd,yd,Dpc0)  , colorbar, title('Differential phase shift (no noise)'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,5),colormap gray,imagesc(xd,yd,Dci0)  , colorbar, title('Amplitude (no noise)'),xlabel('x ({\mu}m)');ylabel('y ({\mu}m)');
subplot(3,2,2),plot(xd,Abs0(round(end/2),:));
subplot(3,2,4),plot(xd,Dpc0(round(end/2),:));
subplot(3,2,6),plot(xd,Dci0(round(end/2),:));

figure(12),clf, imagesc(V0), title('visibility map')

figure(13),clf
for i = 1:scanStep
    subplot(scanStep,1,i),imshow(IdphotonNoise(:,:,i),[]),colorbar;
end
