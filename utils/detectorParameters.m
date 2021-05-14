%% Detector properties
detectorResolutionSpherical=9e-6;   %[m] detector size
detectorResolution=9e-6/M;  %detector resolution demaginified on G1 plane

if realDetector
    %quantum efficiency
    phosphor = 'Gd2O2S';
    phosphorThickness = 5e-2;%5e-2;   %[kg/m2]
    quantumEfficiency = calculateQE(phosphor,phosphorThickness,...
        energies);  
    
    %detector sensitivity
    energyResponse = energies;  %[eV] linear response
    detectorSensitivity = 11.2e-5; %[counts/eV]
    %     Photons = Photons.*energyResponse*detectorSensitivity;  %[counts]
    
    %point spread function
    detectorPSFFunc = inline('0.90034*exp(-x.^2/1.1922e-005.^2) + 0.099613*exp(-x.^2/3.5545e-005.^2) + 5.0889e-005*exp(-x.^2/0.0062821.^2)','x','y');   %general PSF, from XRaySimulator
       
else
    quantumEfficiency = 1;
end