%Calculates the index of refraction n=1-delta-i*beta at given x-ray photon 
%energies of a mixture of chemical compounds given each compounds chemical
%formula and relative density and the density of the mixture.
%Input parameters:
%density - density of mixture [kg/m^3]
%formulas - cell array of chemical formulas for the compounds in the mixture.
%Can look like 'Ag', 'H2O', 'Si3N4' or 'H2O(O(C5H5O(OH)3(CH2OH))2)2.5e-3'.
%relativeDensities - the relative weigth of each compound in the mixture.
%Arbitrary units. The density of each component is calculated like
%densities = relativeDensities/sum(relativeDensities)*density;
%energies - Which energies to calculate the index of refraction for. If
%skipped index of refraction at all available energies are calculated.
function [energies, delta, beta] = calculateIndexOfRefraction(density, ...
    formulas, relativeDensities, energies)
if ~exist('energies','var')
    energies = 'all';
end
if ~iscell(formulas)
    formulas = {formulas};
end

persistent calculated; %Used to save results so they must not be recalculated
if isempty(calculated) %if first call
    calculated = containers.Map(); %create the map
end
mlock; %lock this file in memory so that calculated is saved
key = [formulas{:} '_' num2str(density) '_' num2str(relativeDensities) '_'...
    num2str(sum(energies))]; %for identification
if isKey(calculated,key) %if already calculated
    energies = calculated(key).energies;
    delta = calculated(key).delta;
    beta = calculated(key).beta;
    return;
end

if ischar(formulas) %if single string not in cell array
    formulas = {formulas}; %make cell array
end
if length(formulas) == 1 %if only one component
    relativeDensities = 1;
end
%absolute densities of the components
densities = relativeDensities/sum(relativeDensities)*density;

if strcmpi(energies,'all')
    energies = [];
    fixedEnergies = false;
else
    fixedEnergies = true;
end

%Get symbols and atomic weigths of the elements
file = fopen('utils/scatteringFactors/elements.txt');
fgetl(file); %read file header
symbols = cell(1,118);
mass = zeros(1,118);
for i = 1:118
    symbols{i} = fscanf(file,'%s',1);
    mass(i) = fscanf(file,'%g',1);
end
fclose(file);

%physical constants
hbar = 1.0546e-34; %Js, Plancks constant/2pi
c = 299792458; %m/s, speed of light in vacuum
qe = 1.6022e-19; %C, electron charge
re = 2.8179402894e-15; %m, classical electron radius
mu = 1.660538782e-27; %kg, atomic mass constant

delta = 0*energies;
beta = 0*energies;
%loop throught all components
for component = 1:length(formulas)
    if isempty(formulas{component})
        continue;
    end
    %parse the chemical formula for this component to get the number of
    %atoms of each element per formula unit
    amount = parseFormula(formulas{component});

    %Sum over all elements in formula to get total formula weight and
    %scattering factors f1 and f2.
    formulaMass = 0; %[u], mass of formula unit
    if (fixedEnergies)
        f1 = 0*energies; %scattering factor
        f2 = 0*energies;
    else
        cEnergies = []; %the energies for this component
        f1 = [];
        f2 = [];
    end
    for element = find(amount)
        formulaMass = formulaMass + mass(element)*amount(element); %[u]
        if (fixedEnergies)
            [dummy,f1e,f2e] = scatteringFactors2(symbols{element},energies);
            f1 = f1+f1e*amount(element);
            f2 = f2+f2e*amount(element);
        else
            %get energies and scattering factors for this element
            [eEnergies,f1e,f2e] = scatteringFactors2(symbols{element});
            %the energies of this and previous elements in component
            newEnergies = unique(sort([cEnergies eEnergies]));
            %add f1 and f2 for this element and interpolate to new energies
            f1 = interpolate(cEnergies,f1,newEnergies) +...
                interpolate(eEnergies,f1e,newEnergies)*amount(element);
            f2 = interpolate(cEnergies,f2,newEnergies) +...
                interpolate(eEnergies,f2e,newEnergies)*amount(element);
            cEnergies = newEnergies; %use the new energies for component
        end
    end
    if fixedEnergies
        newEnergies = energies;
    else
        newEnergies = unique(sort([energies cEnergies]));
    end

    lambda = 2*pi*c*hbar/qe./newEnergies; %m, wavelength
    K = lambda.^2*(re/(2*pi) * densities(component)/(formulaMass*mu));
    if fixedEnergies
        delta = delta + K.*f1;
        beta = beta + K.*f2;
    else
        delta = interpolate(energies, delta, newEnergies) +...
            interpolate(cEnergies, f1, newEnergies).*K;
        beta = interpolate(energies, beta, newEnergies) +...
            interpolate(cEnergies, f2, newEnergies).*K;
        energies = newEnergies;
    end
end

S.energies = energies;
S.delta = delta;
S.beta = beta;
calculated(key) = S;
