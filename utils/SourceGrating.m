function [T2,Transmission]=SourceGrating(N,dx0,dy0,energies,X,Y,plotTransmission)
hbar = 1.0546e-34; %Js, Plancks constant/2pi
c = 299792458; %m/s, speed of light in vacuum
qe = 1.6022e-19; %C, electron charge



x0=[-N/2+1:N/2]*dx0;
y0=[-N/2+1:N/2]*dy0;
bulk = makeObject('bulk'); %create standard bulk
objects(1) = bulk;
objects(1).thickness = 20e-6;
index=2;    %index of objects
% type=1; %refer to {'Ellipsoid' 'Cylinder' 'Box' 'Disc' 'Prism' 'Wedge' 'Grating'}
obj.type='Grating';
obj.thickness=20e-6;   %[m]
obj.width=inf;
obj.height=inf;
obj.period=2e-6;
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
commonMaterials = getCommonMaterials();
material= commonMaterials(17);   %the index of common materials 17 is gold
n.density=material.density;
n.formulas=material.formulas;
n.relativeWeights=material.relativeWeights;
        [n.energies, n.deltaSpectrum, n.betaSpectrum] = ...
            calculateIndexOfRefraction(n.density,n.formulas,...
            n.relativeWeights);
    elseif strcmpi(n.type,'File')
        warning('Index of refraction from file not yet implemented.');
    else
        warning('Unknown type of index of refraction');
    end
    objects(index).n = n;
end
    

% ymax = 1;
% ymin = 1e-10;
% lines = {};
% indices = n.energies<50e3 & n.energies>4e3;
% % plotBeta
%     figure,semilogy(n.energies/1e3, n.betaSpectrum,'green');
%     lines{end+1} = '\beta';
%     ymax = max(ymax, max(n.betaSpectrum(indices)));
%     ymin = min(ymin, min(n.betaSpectrum(indices)));
%     hold on;
% % plotDelta
%     ymax = max([ymax n.deltaSpectrum(indices)]);
%     ymin = min([ymin n.deltaSpectrum(indices & n.deltaSpectrum>0)]);
%     semilogy(n.energies/1e3, max(ymin,n.deltaSpectrum));
%     lines{end+1} = '\delta';
% xlabel('Energy (keV)');
% title('Index of refraction n=1-\delta+i\beta');
% xlim([0 50]);
% ylim([ymin ymax]);
% legend(lines);
% hold off;
% plot transmission
phase = zeros(size(X));
p1=objects(2).period; %number of periods of the grating
w1=3*p1/4;
% k=1;
t=zeros(size(X));
    R = 1:size(X,1);
            C = 1:size(X,2);
for j=1:N
for l=1:round(N*dx0/p1); %number of periods of the grating
  %t(j)=dirac(j-i*np1);  %multi-slit grating
  if (j*dx0-l*p1)/w1<=0&&(j*dx0-l*p1)/w1>-.9999 %if use 1, situation like 1.0000>1 will occur. don't know why.
      t(:,j)=objects(2).thickness; 
      %assume the phase depth is pi 
      %thus the periodicity of the fringe pattern is g1/2, according to weitkamp05
  end
end
end
absorption = ones(size(X));
for energyIndex = 1:length(energies)
    energy = energies(energyIndex);
     k = energy*qe/(c*hbar); %1/m, wave number
    [dummy, delta, beta] = calculateIndexOfRefraction(objects(2).n.density,...
            objects(2).n.formulas, objects(2).n.relativeWeights, energy);
        phase(R,C) = phase(R,C) - t*delta*k;
        [mu, muEn] = calculateAbsorptionCoef(objects(2).n.density,...
            objects(2).n.formulas, objects(2).n.relativeWeights, energy);
        absorption(R,C) = absorption(R,C).*exp(-mu*t/2);
        Transmission(:,:,energyIndex)=absorption;
Phase(:,:,energyIndex)=phase;
T2(:,:,energyIndex)=Transmission(:,:,energyIndex).*exp(1i.*Phase(:,:,energyIndex));  %%Electrical field just
% after object in normalized units
end
% figure,colormap(gray), imagesc(x0,y0,real(exp(-1i.*phase))), colorbar, title('imaginary part after grating 1')
% figure,colormap(gray), imagesc(x0,y0,real(Fobj(:,:,1))), colorbar, title('imaginary part after grating 1')
phase=Phase(:,:,ceil(end/2));  %just for plot transmission
amplitude=Transmission(:,:,ceil(end/2));
if plotTransmission
%plot phase shift
    figure,subplot(1,2,1),plot(x0*1e6,-phase(ceil(end/2),:));
    xlabel('x ({\mu}m)');
    subplot(1,2,2),imagesc(x0*1e6, y0*1e6,-phase);
    set(gca,'YDir', 'normal');
    axis('image');
    ylabel('y ({\mu}m)');
    colorbar('FontSize',10);
xlabel('x ({\mu}m)');
title('Transmission phase (\int{}k\delta{}dz)');
%plot amplitude transmission
figure,
% subplot(1,2,1),plot(x0*1e6,amplitude(ceil(end/2),:));
% xlabel('x ({\mu}m)');
% subplot(1,2,2),imagesc(x0*1e6, y0*1e6,amplitude);
imagesc(x0*1e6, y0*1e6,amplitude);
    set(gca,'YDir', 'normal');
    ylabel('y ({\mu}m)');
    axis('image');
    colormap gray;
    colorbar('FontSize',10);
xlabel('x ({\mu}m)');
title('G2 amplitude transmission');
end
