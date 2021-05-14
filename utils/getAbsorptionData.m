%Returns the absorption coefficient/density for the element with atomic
%number Z in units of cm^2/g.
%If E is given the data is interpolated to these energies.
%The intensity in the beam will go down as I = I0*exp(mu*rho*x), where rho
%is the density of the material,x is the thickness and mu is the first
%output parameter of this function.
function [mu, muEn, E] = getAbsorptionData(Z,E)
file = sprintf('utils/nist/z%02d.html',Z);
lines = textread(file,'%[^\n]');
start = find(strcmp(lines,'<SUP>&nbsp;</SUP>(MeV)      (cm<sup>2</sup>/g)     (cm<sup>2</sup>/g)'))+2;
finish = find(strcmp(lines,'</PRE></TD>'));
E1 = zeros(1,finish-start);
mu1 = zeros(1,finish-start);
muEn1 = zeros(1,finish-start);
for i = 1:finish-start
    line = lines{i+start-1};
    data = str2num(line(max(1,end-34):end));
    E1(i) = data(1)*1e6; %energy in eV
    mu1(i) = data(2); %mu/rho in cm2/g
    muEn1(i) = data(3); %mu_en/rho in cm2/g
end

if nargin==2 %if photon energies are given, interpolate
    mu = zeros(size(E));
    muEn = zeros(size(E));
    edges = [1 find(E1(2:end)==E1(1:end-1))+1 length(E1)];
    %interpolate separetely each region between absorption edges
    for i = 1:length(edges)-1
        Ei = (E>=E1(edges(i)))&(E<E1(edges(i+1)));
        E1i = edges(i):edges(i+1)-1;
        mu(Ei) = interp1(E1(E1i),mu1(E1i),E(Ei),'PCHIP');
        muEn(Ei) = interp1(E1(E1i),muEn1(E1i),E(Ei),'PCHIP');
    end
%     E1 = E1+[0 (E1(2:end)==E1(1:end-1))*1e-10]; %to make all energies unique
%     mu = interp1(E1,mu,E,'linear');
%     muEn = interp1(E1,muEn,E,'linear');
else
    mu = mu1;
    muEn = muEn1;
    E = E1;
end