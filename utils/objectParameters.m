% define objects(2)ect

if useObject
    %object 1 is bulk, liquid paraffin
    bulk = makeObject('bulk'); %create standard bulk
    objects(1) = bulk;
    objects(1).thickness=0.018;  %[m] Thickness of liquid paraffin
    objects(1).n.density=864;  %[kg/m3] Density of liquid paraffin.
    objects(1).n.formulas='C20H42';  %C20H42 density is only 791 kg/m3. What is the composition of liquid paraffin?
    objects(1).n.relativeWeights=1;    %Assume only C20H42.
    objects(1).n.type='Composition';
    
    % object 2 is a PET cylinder
    %refer to {'Ellipsoid' 'Cylinder' 'Box' 'Disc' 'Prism' 'Wedge' 'Grating'}
    objects(2).type='Cylinder';
    objects(2).thickness=213e-6;         %[m]
    objects(2).width=213e-6;   %[m] Magnification due to distance between objects(2)ect and G1.
    objects(2).height=inf;
    objects(2).period=Inf;
    objects(2).name='Wire 1';
    objects(2).rotation=0; %[rad]
    objects(2).x=0;
    objects(2).y=0;
    objects(2).n.type='Composition';   %or 'Constant'
    objects(2).n.delta= [];
    objects(2).n.beta= [];
    objects(2).n.density= [];
    objects(2).n.formulas= [];
    objects(2).n.relativeWeights= [];
    objects(2).n.energies = []; %energies for deltaSpectrum and betaSpectrum
    objects(2).n.deltaSpectrum = [];
    objects(2).n.betaSpectrum = [];
    
    
    n = objects(2).n;
    if isempty(n.deltaSpectrum) || isempty(n.betaSpectrum)
        if strcmpi(n.type,'Constant')
            n.energies = [1 1e5];
            n.deltaSpectrum = [n.delta n.delta];
            n.betaSpectrum = [n.beta n.beta];
        elseif strcmpi(n.type,'Composition')
            commonMaterials = getCommonMaterials();
            material= commonMaterials(10);   %125 is 'PET'
            n.density=material.density;
            n.formulas=material.formulas;
            n.relativeWeights=material.relativeWeights;
        elseif strcmpi(n.type,'File')
            warning('Index of refraction from file not yet implemented.');
        else
            warning('Unknown type of index of refraction');
        end
        objects(2).n = n;
    end
end
