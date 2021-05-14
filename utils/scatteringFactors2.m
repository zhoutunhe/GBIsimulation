%returns the scattering factors f1 and f2 for the given element (e.g. 'Si'
%or 14) at the energies energies (eV) using linear interpolation between
%data points in files in folder 'scatteringFactors2' from:
%ftp://www-phys.llnl.gov/pub/rayleigh/asftab/
%WHICH WAS LINKED THROUGH NIST AFFILLIATE
%if energies is skipped or set to 'all' scattering factors for all energies
%in the file are returned.
function [energy, f1, f2] = scatteringFactors2(element, energies)
[atomicNumbers, symbols] = getElements();
if ischar(element)
    symbol = element;
    Z = atomicNumbers(element);
else
    symbol = symbols(element);
    Z = element;
end
%open the data file for the given element.
file = fopen(['scatteringFactors2/' num2str(floor(Z/10))...
    num2str(mod(Z,10)) '_' symbol '_asf']);
fgetl(file); %read file header
line = '';
while ~feof(file) && ~isequal(line,...
        '      E (keV)          g''''           g''           f''           f1')
    line = fgetl(file);
end
if feof(file)
    warning(['Error parsing file '''...
        'scatteringFactors2/' num2str(Z) '_' symbol '.nff.']);
end
V = fscanf(file,'%g')';
energy = V(1:5:end)*1e3;
f1 = V(5:5:end);
f2 = -V(2:5:end);
fclose(file);
if exist('energies','var') && ~strcmpi(energies,'all')
    if energies(1) < energy(1)
        warning(['There are only scattering factors for energies down to'...
            num2str(energy(1)) ' eV and those for energy ' ...
            num2str(energies(1)) ' where requested. Using scattering'...
            ' factors extrapolated from minimum energy.']);
    end
    if energies(end) > energy(end)
        warning(['There are only scattering factors for energies up to '...
            num2str(energy(end)) ' eV and those for energy ' ...
            num2str(energies(end)) ' where requested. Using scattering'...
            ' factors extrapolated from maximum energy.']);
    end
    f1 =  interp1(energy,f1,energies);
    %interpolates assuming f2 approximatly proportional to energy^-2
    f2 =  interp1(energy,f2.*energy.^2,energies)./energies.^2;
    energy = energies;
end