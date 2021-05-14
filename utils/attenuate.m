%Calculates the strength of a spectrum after having passed through some
%materials. Negative material thicknesses corresponds to the strength the
%spectrum must have had before passing through that thickness of the
%material. The spectrum is however not increased for energies below 6 keV.
%Input paramters:
%energies - [eV] The photon energies in the spectrum.
%intensities - [a.u.] The strength of the spectrum before materials.
%formulas - A cell array of chemical formulas for the materials.
%densities - [kg/m^3] A cell array of the same length as formulas
%containing the density of each material.
%thicknesses - [m] A cell array of the same length as formulas containing
%the thickness of each material.
%source says what data should be used to calculate the
%absorption. It can be either 'mu', 'muEn' or 'beta'.
function intensities = attenuate(energies, intensities,...
    formulas, densities, thicknesses, source)
if ~iscell(formulas)
    formulas = {formulas};
end
if ~iscell(densities)
    densities = {densities};
end
if ~iscell(thicknesses)
    thicknesses = {thicknesses};
end
if isempty(intensities)
    intensities = ones(size(energies));
end
if nargin < 6
    source = 'mu';
end

hbar = 1.0546e-34; %Js, Plancks constant/2pi
c = 299792458; %m/s, speed of light in vacuum
qe = 1.6022e-19; %C, electron charge
k = energies*(qe/(c*hbar)); %1/m, wave number

for i = 1:length(formulas)
    if isempty(formulas{i})
        continue;
    end
    
    if strcmpi(source,'beta')
        [dummy delta beta] =...
            calculateIndexOfRefraction(densities{i},formulas{i},1,energies);
        absorption = exp(-2*k.*beta*thicknesses{i});
    else
        [mu, muEn] = calculateAbsorptionCoef(densities{i},...
            formulas{i}, 1, energies);
        if strcmpi(source, 'mu')
            absorption = exp(-mu*thicknesses{i});
        elseif strcmpi(source, 'muEn')
            absorption = exp(-muEn*thicknesses{i});
        else
            warning(['Unknown absorption data source: ' source]);
            absorption = exp(-mu*thicknesses{i});
        end
    end
    if thicknesses{i} < 0; %if negative thickness
        absorption(energies<6000) = 1; %no increase for energies below 6 keV
    end
    intensities = intensities.*absorption;
end
