%name: useSpectrum
%
%Get a spectrum from folder, divide into n intervals and find the energy of
%each interval and its weight.
%
function [starts,weights,SimulateEnergies]=useSpectrum(filename,Nintervals,absorbers,plotSpec,optimalPar,power)
spectrum=readSpectrumFile2(filename);
if nargin < 6
    power = spectrum.voltage*spectrum.current*1e-3; %[uA]*[kV]  
end
photons=zeros(1,length(spectrum.data)); %[ph/s/W/sr]*[W]
for i = 1:length(spectrum.data)
    if isempty(spectrum.data(i))
        photons(i) = 0;
    else
        photons(i) = spectrum.data(i)*power;
    end
end
%The photon energy for each data point [keV]
cChannels=spectrum.calibrationChannel';
cEnergies=spectrum.calibrationEnergy';
energies = calibrate(cChannels+1,cEnergies,length(spectrum.data));
%remove initial and trailing channels containing zero photons
first = find(photons,1);
last = find(photons,1,'last');
photons = photons(first:last);
energies = energies(first:last);
% qe = 1.60217646e-19; %C, elementary charge
% oldPower = 1000*qe*4*pi*sum(photons.*energies);%[W] radiant
% photons = photons*(newPower/oldPower);

% figure(2),plot(energies,photons);
% xlabel('Energy (keV)')
% ylabel('Photon Number')
% cChannels = cChannels-first+1;
% qe = 1.60217646e-19; %C, elementary charge
% power = sum(energies.*photons)*1000*qe*4*pi;%[W], radiant
% efficiency = power./(spectrum.voltage*spectrum.current);
% if isempty(efficiency)
%     efficiency = .001;
% end
photons2 = attenuate(energies*1e3, photons,...
    absorbers(:,1)',absorbers(:,2)',absorbers(:,3)');
if plotSpec
    figure(5), plot(energies,photons2)
    xlabel('Energy (keV)')
    ylabel('Photon Number')
end

%Partitioning method
if optimalPar
    [starts,centers,weights] = ...% weights is an N element row vector with the total weight within each interval
        optimalPartitioning(Nintervals,energies, photons2);%Given Nintevals (number of intervals in partitioning), w_i (weight), e_i (energy),
else
    [starts,centers,weights] = ...% weights is an N element row vector with the total weight within each interval
        quickPartitioning(Nintervals,energies, photons2);%Given Nintevals (number of intervals in partitioning), w_i (weight), e_i (energy),
end

SimulateEnergies = centers*1e3; %[eV]
if plotSpec
    hold on
    %plot simulation partitioning
    %starts of intervals
    starts = energies(min(end,starts));
    plot([starts;starts],ylim'*ones(size(starts)),'red');
    %plot simulation energies and weigths
    yLim = ylim;
    plot(centers, weights/...
        max(weights)*yLim(2)*.9,'x','color','black','markersize',10,'linewidth',2);
    hold off
end
