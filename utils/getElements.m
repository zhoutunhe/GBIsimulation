%Returns a map atomicNumbers containing the atomic number of each element
%and a list symbols containing the chemical symbol of each element.
function [atomicNumbers symbols masses] = getElements()
file = fopen('scatteringFactors/elements.txt');
fgetl(file);  %read file header
symbols = cell(1,118);
masses = 1:118;
atomicNumbers = containers.Map();
for i = 1:118
    symbols{i} = fscanf(file,'%s',1); %read symbol
    atomicNumbers(symbols{i}) = i;
    masses(i) = fscanf(file,'%g',1); %read past mass
end
fclose(file);