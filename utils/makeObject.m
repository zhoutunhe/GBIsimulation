function obj = makeObject(kind, spec)
if ~exist('kind','var') || strcmpi(kind,'default')
    obj.type = 'Ellipsoid';
    obj.thickness = 20e-6; %m
    obj.width = 20e-6; %m
    obj.height = 20e-6; %m
    obj.period = Inf; %m
    obj.name = 'Default object';
    obj.rotation = 0; %rad
    obj.x = 0; %m
    obj.y = 0; %m
    obj.n = makeIndexOfRefraction();
elseif strcmpi(kind,'random')
    types = {'Ellipsoid' 'Cylinder' 'Box' 'Disc' 'Prism' 'Wedge' 'Grating'};
    type = ceil(rand()*length(types));
    obj.type = types{type};
    L = .6*spec;
    obj.thickness = round((rand()*.6+.4)*100)/100*L; %m
    obj.width = round((rand()*.6+.4)*100)/100*L; %m
    obj.height = round((rand()*.6+.4)*100)/100*L; %m
    if strcmp(obj.type,'Grating')
        obj.period = obj.width/(2+13*rand());
    else
        obj.period = Inf; %m
    end
    obj.name = ['Random ' num2str(floor(2/rand()+5*rand()))];
    obj.rotation = rand()*2*pi; %rad
    obj.x = round((rand()*2-1)*100)/100*L; %m
    obj.y = round((rand()*2-1)*100)/100*L; %m
    obj.n = makeIndexOfRefraction();
    obj.n.delta = round(rand()*100)/100*4e-6;
    obj.n.beta = round(rand()*100)/100*4e-9;
elseif strcmpi(kind,'bulk')
    obj.type = 'Box';
    obj.thickness = 1e-2; %[m]
    obj.width = inf;
    obj.height = inf;
    obj.period = inf;
    obj.name = 'Bulk';
    obj.rotation = 0;
    obj.x = 0;
    obj.y = 0;
    obj.n = makeIndexOfRefraction();
    obj.n.formulas = {['(N2)780840(O2)209460Ar9340(CO2)383Ne18.18']};
    obj.n.density = 1.2; %[kg/m^3]
end

function n = makeIndexOfRefraction()
n.type = 'Composition';
n.delta = 2e-6;
n.beta = 2e-9;
n.formulas = {'C8H8'};
n.density = 1050; %[kg/m^3]
n.relativeWeights = 1;
n.fileName = '';
n.energies = []; %energies for deltaSpectrum and betaSpectrum
n.deltaSpectrum = [];
n.betaSpectrum = [];