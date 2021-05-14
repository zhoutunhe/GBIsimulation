%[T10,Transmission,Phase,objects]=phaseGrating_Ni(p1,w1,N,dx0,energies,X,x0,y0,plotTransmission,energymiddle,xmin,xmax,ymin,ymax)
%To simulate the phase grating: #10-915P-110530LSd, p1=4.12 um, h1=10-11 um, Material: Ni, Substrate Ti, 50 micron thickness

function [T10,Transmission,Phase,objects]=phaseGrating_Ni_Ti(p1,w1,N,dx0,energies,X,x0,y0,plotTransmission,energymiddle,xmin,xmax,ymin,ymax)

% Ni grating
index=2;
% type=1; %refer to {'Ellipsoid' 'Cylinder' 'Box' 'Disc' 'Prism' 'Wedge' 'Grating'}
obj.type='Grating';
obj.width=inf; %xmax-xmin;
obj.height=inf; %ymax-ymin;
obj.thickness = 10e-6;  %[m]
obj.period=p1;
obj.name='grating 1';
obj.rotation=0; %[rad]
obj.x=0;
obj.y=0;
obj.n.type='Composition';   %or 'Constant'
obj.n.delta= [];
obj.n.beta= [];
obj.n.density= [];
obj.n.formulas= [];
obj.n.relativeWeights= [];
obj.n.energies = []; %energies for deltaSpectrum and betaSpectrum
obj.n.deltaSpectrum = [];
obj.n.betaSpectrum = [];
objects(index) = obj;   %only consider one object so far

%Plots the index of refraction for the selected object.
n = objects(index).n;
if isempty(n.deltaSpectrum) || isempty(n.betaSpectrum)
    if strcmpi(n.type,'Constant')
        n.energies = [1 1e5];
        n.deltaSpectrum = [n.delta n.delta];
        n.betaSpectrum = [n.beta n.beta];
    elseif strcmpi(n.type,'Composition')
        %commonMaterials
        n.density=8.908e3;  %[kg/m3] Ni, from WIki.
        n.formulas='Ni';
        n.relativeWeights=1;
        [n.energies, n.deltaSpectrum, n.betaSpectrum] = ...
            calculateIndexOfRefraction(n.density,n.formulas,...
            n.relativeWeights,energymiddle);
    elseif strcmpi(n.type,'File')
        warning('Index of refraction from file not yet implemented.');
    else
        warning('Unknown type of index of refraction');
    end
    objects(index).n = n;
end
hbar = 1.0546e-34; %Js, Plancks constant/2pi
c = 299792458; %m/s, speed of light in vacuum
qe = 1.6022e-19; %C, electron charge
% objects(index).thickness=pi*c*hbar/qe/energymiddle/n.deltaSpectrum %[m]
k = energymiddle*qe/(c*hbar);
objects(2).thickness*n.deltaSpectrum*k;

%Si substrate.
index=3;    %index of objects
% type=1; %refer to {'Ellipsoid' 'Cylinder' 'Box' 'Disc' 'Prism' 'Wedge' 'Grating'}
obj.type='Box';
obj.width=inf; %xmax-xmin;
obj.height=inf; %ymax-ymin;
obj.thickness=50e-6;   %[m]
obj.period=0;
obj.name='Substrate';
obj.rotation=0; %[rad]
obj.x=0;
obj.y=0;
obj.n.type='Composition';   %or 'Constant'
obj.n.delta= [];
obj.n.beta= [];
obj.n.density= [];
obj.n.formulas= [];
obj.n.relativeWeights= [];
obj.n.energies = []; %energies for deltaSpectrum and betaSpectrum
obj.n.deltaSpectrum = [];
obj.n.betaSpectrum = [];
objects(index) = obj;   %only consider one object so far

%Plots the index of refraction for the selected object.
n = objects(index).n;
if isempty(n.deltaSpectrum) || isempty(n.betaSpectrum)
    if strcmpi(n.type,'Constant')
        n.energies = [1 1e5];
        n.deltaSpectrum = [n.delta n.delta];
        n.betaSpectrum = [n.beta n.beta];
    elseif strcmpi(n.type,'Composition')
        n.density=4506; %[kg/m3] from Wiki.
        n.formulas='Ti';
        n.relativeWeights=1;
        [n.energies, n.deltaSpectrum, n.betaSpectrum] = ...
            calculateIndexOfRefraction(n.density,n.formulas,...
            n.relativeWeights,energymiddle);
    elseif strcmpi(n.type,'File')
        warning('Index of refraction from file not yet implemented.');
    else
        warning('Unknown type of index of refraction');
    end
    objects(index).n = n;
end


% Grating period is calculated from the (1,1) instead of center. If use
% code from XRaySimulator for grating, the center part may not have the
% same period, but will be symmetric.


% k=1;
t=zeros(size(X));
R = 1:size(X,1);
C = 1:size(X,2);
%             t = objectThickness(objects(2),X(R,C),Y(R,C));
for j=1:N
    for l=1:round(N*dx0/p1); %number of periods of the grating
        %t(j)=dirac(j-i*np1);  %multi-slit grating
        if (j*dx0-l*p1)/w1<=0&&(j*dx0-l*p1)/w1>-0.9999
            t(:,j)=objects(2).thickness;
            %assume the phase depth is pi
            %thus the periodicity of the fringe pattern is g1/2, according to weitkamp05
        end
    end
end

Transmission = ones(size(X,1),size(X,2),length(energies));
Phase = zeros(size(X,1),size(X,2),length(energies));
T10 = ones(size(X,1),size(X,2),length(energies));
for energyIndex = 1:length(energies)
    energy = energies(energyIndex);
    k = energy*qe/(c*hbar); %1/m, wave number
    phase = zeros(size(X));
    absorption = ones(size(X));
    
    % Grating.
    [dummy, delta, beta] = calculateIndexOfRefraction(objects(2).n.density,...
        objects(2).n.formulas, objects(2).n.relativeWeights, energy);
    phase(R,C) = phase(R,C) - t*delta*k;
    [mu, muEn] = calculateAbsorptionCoef(objects(2).n.density,...
        objects(2).n.formulas, objects(2).n.relativeWeights, energy);
    absorption(R,C) = absorption(R,C).*exp(-mu*t/2);
        
    % Substrate.
    [dummy, delta, beta] = calculateIndexOfRefraction(objects(3).n.density,...
        objects(3).n.formulas, objects(3).n.relativeWeights, energy);
    phase(R,C) = phase(R,C) - objects(3).thickness*delta*k;
    [mu, muEn] = calculateAbsorptionCoef(objects(3).n.density,...
        objects(3).n.formulas, objects(3).n.relativeWeights, energy);
    absorption(R,C) = absorption(R,C).*exp(-mu*objects(3).thickness/2);
        
    % Wavefront after object in normalized units
    Transmission(:,:,energyIndex)=absorption;
    Phase(:,:,energyIndex)=phase;
    T10(:,:,energyIndex)=Transmission(:,:,energyIndex).*exp(1i*Phase(:,:,energyIndex));  %%Electrical field just
end
% figure,colormap(gray), imagesc(x0,y0,real(exp(-1i.*phase))), colorbar, title('imaginary part after grating 1')
% figure,colormap(gray), imagesc(x0,y0,real(Fobj(:,:,1))), colorbar, title('imaginary part after grating 1')


% Plot transmission image
phase=Phase(:,:,ceil(end/2)) ; 
amplitude=Transmission(:,:,ceil(end/2));
if plotTransmission
    %plot phase shift
    %     figure,subplot(1,2,1),plot(x0*1e6,-phase(ceil(end/2),:));
    %     xlabel('x ({\mu}m)');
    %     subplot(1,2,2),imagesc(x0*1e6, y0*1e6,-phase);
    %     set(gca,'YDir', 'normal');
    figure,plot(x0*1e6,-phase(ceil(end/2),:));
    xlabel('x ({\mu}m)');
    %     axis('image');
    ylabel('{\phi}');
    %     colorbar('FontSize',11);
    % xlabel('x ({\mu}m)');
    title('G1 transmission phase (\int{}k\delta{}dz)');
    %plot amplitude transmission
    figure,
    subplot(1,2,1),plot(x0*1e6,amplitude(ceil(end/2),:));
    xlabel('x ({\mu}m)');
    subplot(1,2,2),imagesc(x0*1e6, y0*1e6,amplitude);
    set(gca,'YDir', 'normal');
    ylabel('y ({\mu}m)');
    axis square;
    colorbar('FontSize',11);
    xlabel('x ({\mu}m)');
    title('Transmission amplitude exp(-\int{}k\beta{}dz)');
end