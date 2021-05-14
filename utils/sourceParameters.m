% source parameters
sourcewidth=3.57e-6;    %x-FWHM
sourceheight=6.84e-6;   %y-FWHM

if oneEnergy
    %monochromatic source
    energies = 22387; %[eV] designed photon energy
    energymiddle=22387;
    Lambda=1239.842/energies*1e-9; %wavelength [m]
    power = 10; %[W]
    efficiency =.1/100;
    Photons = power*efficiency/(4*pi)/(qe*energies); %[1/s/sr]
    Lambdamiddle=Lambda;
    
else
    
    %spectrum source
    filename=[pwd '\utils\spectrum\40W 5deg 1.5m vacuum unfiltered.mca']; %In65Ga35 30W 1.5m 2011-05-12.mca
    Nintervals=30;
    % newPower=40*0.096535/100; %power = sum(handles.energies.*handles.photons)*1000*qe*4*pi;%[W], radiant %efficiency = power./(voltage*current);
    
    
    %filter
    absorbers={'C5H8O2',1.19*1e3,0.001,true;
        'C5H8O2',1.19*1e3,0.001,false;
    '(N2)780840(O2)209460Ar9340(CO2)383Ne18.18He5.24(CH4)1.745Kr1.14(H2)0.55',1.2,0.86,true;
    '(N2)780840(O2)209460Ar9340(CO2)383Ne18.18He5.24(CH4)1.745Kr1.14(H2)0.55',1.2,0.095,false};  %formula,density(kg/m3),thickness(m)
    %PMMA (0.001 should be after, but now I'm only doing simulation not considering about dose.)
    %Only consider absorber before the
    %object when calculating dose; consider both before and after for simulation
    plotSpec=0;                           %Plot the spectrum.
    optimalPar=1;                         %Use optimal or quick partition method.
    [starts,Photons,energies]=useSpectrum(filename,Nintervals,absorbers,plotSpec,optimalPar);
    
    Lambda=1239.84187./energies*1e-9;            %Wavelengths  for all energies. [m]
    energymiddle=25e3;                           %Energy used to for grating thickness and distances. (eV)
    Lambdamiddle=1239.84187/energymiddle*1e-9;   %Wavelength used for grating thickness and distances. (m)
end