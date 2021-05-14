%Calculates the quantum efficiency of a phosphor at a range of energies
%assuming it is equal to the absorbed fraction of x-rays at those energies.
%phosphor - The chemical composition of the phosphor e.g. Gd2O2STb
%thickness - [kg/m^2] mass phosphor per area.
%energies - The energies for which to calculate the QE
function quantumEfficiency = calculateQE(phosphor, thickness, energies)
quantumEfficiency = 1-attenuate(energies, 1, phosphor, 1, thickness, 'muEn');