%Calculates the absorption coefficient (mu) and energy absorption 
%coefficient (muEn) at given x-ray photon energies of a mixture of
%chemical compounds given each compounds chemical formula and relative
%density and the density of the mixture. The unit of mu and muEn is 1/m.
%Input parameters:
%density - density of mixture [kg/m^3]
%formulas - cell array of chemical formulas for the compounds in the mixture.
%Can look like 'Ag', 'H2O', 'Si3N4' or 'H2O(O(C5H5O(OH)3(CH2OH))2)2.5e-3'.
%relativeDensities - the relative weigth of each compound in the mixture.
%Arbitrary units. The density of each component is calculated like
%densities = relativeDensities/sum(relativeDensities)*density;
%energies - Which energies to calculate the index of refraction for in eV.
function [mu, muEn] = calculateAbsorptionCoef(density, ...
    formulas, relativeDensities, energies)
if ~iscell(formulas) %if single string not in cell array
    formulas = {formulas}; %make cell array
end

% persistent calculated2; %Used to save results so they must not be recalculated
% if isempty(calculated2) %if first call
%     calculated2 = containers.Map(); %create the map
% end
% mlock; %lock this file in memory so that calculated is saved
% key = [formulas{:} '_' num2str(density) '_' num2str(relativeDensities) '_'...
%     num2str(sum(energies))]; %for identification
% if isKey(calculated2,key) %if already calculated
%     energies = calculated2(key).energies;
%     delta = calculated2(key).delta;
%     beta = calculated2(key).beta;
%     return;
% end

if length(formulas) == 1 %if only one component
    relativeDensities = 1;
end
%absolute densities of the components
densities = relativeDensities/sum(relativeDensities)*density;

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
u = 1.660538782e-27; %kg, atomic mass constant
lambda = 2*pi*c*hbar/qe./energies; %m, wavelength

mu = zeros(size(energies)); %[1/m] total absorption coefficient
muEn = zeros(size(energies)); %[1/m] total energy absorption coefficient

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

    mup = zeros(size(energies)); %part absorption coefficient
    muEnp = zeros(size(energies)); %part energy absorption coefficient
    
    for element = find(amount)
        formulaMass = formulaMass + mass(element)*amount(element); %[u]
        [mupp, muEnpp] = getAbsorptionData(element,energies); %[cm2/g]
        mup = mup+mupp*mass(element)*amount(element);
        muEnp = muEnp+muEnpp*mass(element)*amount(element);
    end

    mu = mu + mup*densities(component)/formulaMass/10;
    muEn = muEn + muEnp*densities(component)/formulaMass/10;
end

% S.energies = energies;
% S.delta = delta;
% S.beta = beta;
% calculated(key) = S;
