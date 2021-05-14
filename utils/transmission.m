%returns the phase shift and amplitude absorption of x-rays of energy
%energy (eV) throughout the area with x-coordinates and y-coordinates
%given by the matrices X and Y
%absorptionSource says what data should be used to calculate the absorption. It
%can be either 'mu', 'muEn' or 'beta'.
function [phase absorption] = transmission(objects, energy, X, Y, absorptionSource)
if nargin == 4
    absorptionSource = 'mu';
end

hbar = 1.0546e-34; %Js, Plancks constant/2pi
c = 299792458; %m/s, speed of light in vacuum
qe = 1.6022e-19; %C, electron charge
k = energy*qe/(c*hbar); %1/m, wave number

bulk = objectThickness(objects(1),X,Y); %the bulk thickness throughout the object
phase = zeros(size(X));
absorption = ones(size(X));
for i = [2:length(objects) 1]
    object = objects(i);
    if i == 1
        t = bulk;
        C = 1:size(X,2);
        R = 1:size(Y,1);
    else
        %Makes calculation of object thickness faster but doesn't work with
        %Flat edge or Round edge
        needSpeed = false;
        if (needSpeed)
            radius = sqrt(object.width^2+object.height^2);
            cmin = max(1,floor(1+(object.x-radius-X(1,1))/(X(1,2)-X(1,1))));
            cmax = min(size(X,2),ceil(1+(object.x+radius-X(1,1))/(X(1,2)-X(1,1))));
            C = cmin:cmax;
            rmin = max(1,floor(1+(object.y-radius-Y(1,1))/(Y(2,1)-Y(1,1))));
            rmax = min(size(Y,1),ceil(1+(object.y+radius-Y(1,1))/(Y(2,1)-Y(1,1))));
            R = rmin:rmax;
        else
            R = 1:size(X,1);
            C = 1:size(X,2);
        end
        t = objectThickness(object,X(R,C),Y(R,C));
            
    end
    if strcmpi(object.n.type,'Constant')
        delta = object.n.delta;
        beta = object.n.beta;
    elseif strcmpi(object.n.type,'Composition')
        [dummy, delta, beta] = calculateIndexOfRefraction(object.n.density,...
            object.n.formulas, object.n.relativeWeights, energy);      
    elseif strcmpi(object.n.type,'File')
        warning(['Transmission not inplemented for index of refraction' ...
            'from file.']);
    else
        warning('Unknown index of refraction type.');
    end
    phase(R,C) = phase(R,C) - t*delta*k;    
    if i == 1 %if bulk
        if min(min(bulk)) < 0
            warning('Negative bulk thickness.');
        end
        %change the phase so that going through only bulk gives phase = 0
        phase = phase + k*object.thickness*delta;
    end
    if strcmpi(absorptionSource, 'beta')
        absorption(R,C) = absorption(R,C).*exp(-k*t*beta);
    else
        [mu, muEn] = calculateAbsorptionCoef(object.n.density,...
            object.n.formulas, object.n.relativeWeights, energy);
        if strcmpi(absorptionSource, 'mu')
            absorption(R,C) = absorption(R,C).*exp(-mu*t/2);
        elseif strcmpi(absorptionSource, 'muEn')
            absorption(R,C) = absorption(R,C).*exp(-muEn*t/2);
        else
            warning(['Unknown absorptionSource: ' absorptionSource]);
            absorption(R,C) = absorption(R,C).*exp(-mu*t/2);
        end
    end
                
    bulk(R,C) = bulk(R,C) - t; %remove the thickness of this object from the bulk
    end