Transmission = ones(size(X,1),size(X,2),length(energies));
Phase = Transmission;
Fobj = Transmission;
if useObject    
    for energyIndex = 1:length(energies)
        energy = energies(energyIndex);
        [phase, amplitude] = transmission(objects, energy, X, Y);%objects (with sample) %phase is defined inverted, so exp(1i*phase)
        Transmission(:,:,energyIndex)=amplitude;
        Phase(:,:,energyIndex)=phase;
        Fobj(:,:,energyIndex)=amplitude.*exp(1i*phase);  %%Electrical field just after object in normalized units
    end
else
    Fobj=1;
end


%% Phase grating

if useGrating1
    plotTransmission=0;
    [T10,Transmission,Phase,grating1]=phaseGrating_Ni_Ti(p1,w1,Nx,dx0,energies,X,x0,y0,plotTransmission,energymiddle);    %p1,w1,N,dx0,energies,X,x0,y0,plotTransmission,energymiddle,xmin,xmax,ymin,ymax
else
    T10=1;
end
T1=Fobj.*T10;


%% free-space Propagation
F1 = T1;    % preallocate memory to F1
for i=1:length(Lambda)
    [f1]=fresnel2d2(T1(:,:,i),dx0,dy0,zeff,Lambda(i),equalRow);
    F1(:,:,i)=f1;
end

clear T1
clear T10
clear f1
clear f10



%% --------------------------source and source grating--------------------------

if usesourcegeo
    % consider extended source and grating
    fsource=source(X,Y,sourcewidth,sourceheight,1,0,0,l,z ); %the source geometry
    %fsource=source(X,Y,w,h,gaussian,elliptical,square,sourceDist,detectorDist), if not these two kind,
    %default setting is uniform over all area, fsource=1.
    %gaussian: w-FWHMx, h-FWHMy
    %wlliptical: w-width, h-hight
    
    if sourceGrating
        p0=p2; %when scaled to detector plane, they should be the same
        plotTransmission=0;
        [t0,transmission0]=SourceGrating(N,dx0,dy0,energies,X,Y,plotTransmission);
        sourceGratingEfficiencyNum=zeros(size(transmission0,1),size(transmission0,2));
        sourceGratingEfficiencyDen=zeros(size(transmission0,1),size(transmission0,2));
        for energyIndex=1:length(energies)
            sourceGratingEfficiencyNum=Photons(energyIndex).*transmission0(:,:,energyIndex)+sourceGratingEfficiencyNum;
            sourceGratingEfficiencyDen=Photons(energyIndex)*ones(size(sourceGratingEfficiencyDen))+sourceGratingEfficiencyDen;
            fg0(:,:,energyIndex)=fsource.*transmission0(:,:,energyIndex);
        end
        sourceGratingEfficiencyNum=sum(sourceGratingEfficiencyNum);
        sourceGratingEfficiencyDen=sum(sourceGratingEfficiencyDen);
        sourceGratingEfficiency=sourceGratingEfficiencyNum/sourceGratingEfficiencyDen;
        %bright distribution of the source after grating 0, scaled with z/l
    else
        fg0=fsource; %the distribution is the same at the source plane and the object plane, only size decreased.
        sourceGratingEfficiency=1;
    end
    Fg0=fftshift(fft2(fftshift(fg0))); %Fourier transform of wavefront after source grating
else
    Fg0=1;
end
clear fg0
clear fsource
clear t0


%% Second grating + Scan + Detector

if useGrating2
    
    % Absorption Grating
    plotTransmission=0; %remember to change the thickness of grating when changing the photon energy
    [T20,Transmission2]=G2_Au(45e-6,500e-6,p2,w2,Nx,dx0,energies,X,x0,y0,plotTransmission);
    Transmission2=abs(Transmission2).^2;
    
    % Scan, detector
    dx=p2/scanStep;  %distance of each step
    t2scan=Transmission2;  %just to set an initial value
    I2=abs(F1).^2;
  
    Idsourcegeometry1=zeros(size(I2));
    Id0sourcegeometry1=zeros(size(I2));
    Idsourcegeometry=zeros(size(I2));
    Id0sourcegeometry=zeros(size(I2));
    
    for i=1:length(Lambda)
        if usesourcegeo
            Idsourcegeometry1(:,:,i)=ifftshift(ifft2(ifftshift((fftshift(...
                fft2(fftshift(I2(:,:,i)))).*Fg0(:,:)))));   
            %convolve source grating distribution
                        
        else
            Idsourcegeometry1(:,:,i)= I2(:,:,i);
        end
        
        for n=0:scanStep-1  %circulating for scanning
            t2scan(:,:,i)=scanning(Transmission2(:,:,i),n,dx,dx0,round(p2/dx0));
            Idsourcegeometry(:,:,i)=t2scan(:,:,i).*Idsourcegeometry1(:,:,i);
        
            if realDetector
                detectorBlur = detectorPSFFunc(X*M,Y*M);
                Idsourcegeometry(:,:,i) = ifft2...
                    (fft2(Idsourcegeometry(:,:,i))...
                    .*fft2(fftshift(detectorBlur/sum(sum(detectorBlur)))));
            end
          
            [Id(:,:,i,n+1),xd,yd,npixelx]=detector2(X,...
                detectorResolution*1e6,Idsourcegeometry(:,:,i),dx0*1e6,dy0*1e6);
            % function [Id,xd,yd]=detector2(N,pixel,I2,dx0)
            %The minimum size of one pixel is twice period of the second grating, p1.
            %Id=intensity of detector
            %N=length(f0)
            %pixel=size of one pixel
            %I2=intensity after grating 2
           
        end
    end
        
    clear F1
    clear Fg0
    clear t2scan
    clear T2

else
    scanStep=1;
    Idsourcegeometry=zeros(size(F1));
    for i=1:length(Lambda)
        if usesourcegeo
            Idsourcegeometry(:,:,i)=ifftshift(ifft2(ifftshift((fftshift(...
                fft2(fftshift(I2(:,:,i)))).*Fg0(:,:)))));   
            %convolve source grating distribution
                        
        else
            Idsourcegeometry(:,:,i)= I2(:,:,i);
        end
        [Id(:,:,i),xd,yd,npixelx]=detector2(X,detectorResolution*1e6,...
            Idsourcegeometry(:,:,i),dx0*1e6,dy0*1e6);
    end
end


%% adjust visibility
if adjustVisibility
    for i = 1:size(Id,3)
        for j = 1:size(Id,4)
            Id(:,:,i,j) = (Id(:,:,i,j)-mean(Id(:,:,i,:),4))*0.44+mean(Id(:,:,i,:),4);
        end
    end
end


%% noise

PhotonNumberRatio = Photons.*energyResponse*detectorSensitivity*...
    exposureTime*detectorResolutionSpherical^2/Dis_s_d^2.*quantumEfficiency;  
%photon number per pixel

variance = Id;
Idp = Id;

for i=1:length(Lambda)
    variance(:,:,i,:) = Id(:,:,i,:)*PhotonNumberRatio(i)*...
        energyResponse(i)*detectorSensitivity;
    Idp(:,:,i,:)=Id(:,:,i,:)*PhotonNumberRatio(i);   %without noise, photon number
end

variance = sum(variance,3);
variance = squeeze(variance);
Idp=sum(Idp,3);   %total photon number under all energies
Idp = squeeze(Idp);
IdphotonNoise=Idp;

if poissonNoise
    %add photon noise
    IdphotonNoise=poissrnd(Idp); %photon noise, poisson distribution
    
    
elseif gaussianNoise
    IdphotonNoise=normrnd(Idp,variance);
   
    
elseif useNPS
    Idp = squeeze(Idp);
    IdphotonNoise=Idp;

    for j = 1:size(Idp,3)
        IdphotonNoise(:,:,j) = addNoise(Idp(:,:,j),...
            detectorResolutionSpherical, NPS,...
            median(median(variance(:,:,j))),readoutNoise^2);
    end
end


if ~useGrating2
    figure, colormap(gray), imagesc(xd,yd,IdphotonNoise(:,:,1))  , colorbar, title('photon number in detector')
    figure,plot(xd,IdphotonNoise(round(npixely/2),:,1,1)),title('photon number section profiles through the center'),xlabel('x ({\mu}m)');
    figure, colormap(gray), imagesc(xd,yd,Id0photonNoise(:,:,1))  , colorbar, title('photon number in detector (without object)')
    figure,plot(xd,Id0photonNoise(round(npixely/2),:,1,1)),title('photon number section profiles through the center'),xlabel('x ({\mu}m)');
    figure, colormap(gray), imagesc(xd,yd,Id0(:,:,1))  , colorbar, title('photon number in detector (without noise or object)')
    figure,plot(xd,Id0(round(npixely/2),:,1,1)),title('photon number section profiles through the center'),xlabel('x ({\mu}m)');
    figure, colormap(gray), imagesc(xd,yd,Id(:,:,1))  , colorbar, title('intensity in detector(without noise')
    figure,plot(xd,Id(round(npixely/2),:,1,1)),title('photon number section profiles through the center (without noise)'),xlabel('x ({\mu}m)');
end


%% fitting - phase gradient, absorption, amplitude

[A,B,P] = FBA(IdphotonNoise,1);
[A0,B0,P0] = FBA(Idp,1);
Abs = A./median(A0(:));    %change later use mean value instead of (1,1)
Dci = B./A.*median(A0(:))/median(B0(:));
Dpc = angle(exp(1i*(P-median(P0(:)))));
V0 = B./A;
Abs0 = A0./median(A0(:));    %change later use mean value instead of (1,1)
Dci0 = B0./A0.*median(A0(:))/median(B0(:));
Dpc0 = angle(exp(1i*(P0-median(P0(:)))));


%%
plotFitting(dx0*1e6,dx*1e6,scanStep-1,IdphotonNoise,B,P,A)
