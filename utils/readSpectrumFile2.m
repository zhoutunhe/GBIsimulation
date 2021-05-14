% By: Jakob Larsson (originally Ulf Lundström)
% Edited: 2015-01-15
% ----------------------------------------------------------------------
% Modified version of Ulf's "readSpectrumFile.m"
% This script reads the spectrum file, makes corrections for absorption in
% air and kapton windows, and normalizes the spectrum to time, power and
% solid angle. 
% It also makes an energy calibration and stores the energy as "spectrum.E"
%
% The normalized and corrected data is stored as "spectrum.data"
% The normalized but uncorrected data is also stored as "spectrum.dataNoCorr"
% Unmodified data is stored as "spectrum.rawData".
% --------------------------------------------------------------------------
% IMPORTANT
% For the script to work, the measurement parameters must be added to the 
% spectrum .mca file. Add the follow fields below "DESCRIPTION -" in the .mca file: 
% current = xxx uA (typically 100-600 µA)
% voltage = xx kV (typically 50 kV, current*voltage = source power)
% pinhole diameter = xx um (pinhole used when measuring the spectrum)
% distance = x m (distance from source to the spectrometer)
% airDistance = x m (same as distance if vacuum tubes weren't used)
% kaptonThickness = xx um (50 if vacuum tubes were used, 0 otherwise)


function spectrum = readSpectrumFile2(fileName,doPlot)
if nargin<2
    doPlot = 0;
end
spectrum.lines = [];
spectrum.time = []; %[s] live time
spectrum.timeAcc = []; %counts in the fast channel
spectrum.countFast = []; %[s] accumulation time
spectrum.countSlow = []; %counts in the slow channel
spectrum.peaktimeFast = []; %[ns] fast channel peak time
spectrum.serialNumber = []; %detector serial number
spectrum.pinhole = []; %[µm] diameter of pinhole
spectrum.distance = []; %[m] measurement distance
spectrum.voltage = []; %[kV] source voltage
spectrum.current = []; %[mA] source current
spectrum.airDistance = []; %[m] distance the x-rays travel in air
spectrum.kaptonThickness = []; %[µm] thickness of kapton film if vacuum tubes were used
spectrum.calibrationChannel = []; %calibration channels
spectrum.calibrationEnergy = []; %calibration energies
spectrum.rawData = []; %unmodified data
spectrum.corrections = ''; %list of corrections made
spectrum.normalizations = ''; %list of normalizations made

%% Read spectrum file
file = fopen(fileName,'rt');
i = 0;
while ~feof(file)
    i = i+1;
    line = fgetl(file);
    spectrum.lines{i} = line;
    num = regexp(line,'[0-9.]');
    if strncmpi(line,'time',length('time')) ||...
            strncmpi(line,'live_time',length('live_time'))
        spectrum.time = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'pinhole',length('pinhole'))
        spectrum.pinhole = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'distance',length('distance'))
        spectrum.distance = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'current',length('current'))
        spectrum.current = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'voltage',length('voltage'))
        spectrum.voltage = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'airDistance',length('airDistance'))
        spectrum.airDistance = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'kaptonThickness',length('kaptonThickness'))
        spectrum.kaptonThickness = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'Fast Count',length('Fast Count'))
        spectrum.countFast = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'Slow Count',length('Slow Count'))
        spectrum.countSlow = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'Accumulation Time',length('Accumulation Time'))
        spectrum.timeAcc = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'TPFA',length('TPFA'))
        spectrum.peaktimeFast = str2num(line(num(1):num(end)));
    elseif strncmpi(line,'Serial Number',length('Serial Number'))
        spectrum.serialNumber = str2num(line(num(1):num(end)));
    elseif strcmpi(line,'<<CALIBRATION>>') || ...
            strncmpi(line,'calibration',length('calibration'))
        if strcmpi(line,'<<CALIBRATION>>')
            line = fgetl(file);
            if (~strcmpi(line,'LABEL - Channel'))
                warning(['Error in reading callibration data.'...
                    'Expected ''LABEL - Channel'' after ''<<CALIBRATION>>''.']);
            end
        end
        calibration = fscanf(file,'%g'); %read all numbers following
        if ~isempty(calibration)
            i = i+1;
            spectrum.lines{i} = ...
                '[Calibration data moved to calibration table]';
            %the first number and then every second number is assumed to be
            %channels (0-indexed)
            spectrum.calibrationChannel =...
                [spectrum.calibrationChannel calibration(1:2:end)];
            %the second and the every second number is assumed to be energy
            spectrum.calibrationEnergy =...
                [spectrum.calibrationEnergy calibration(2:2:end-mod(end,2))];
        end
    elseif strcmp(line,'<<DATA>>')
        if isempty(spectrum.rawData)
            spectrum.rawData = fscanf(file,'%g');
            if ~isempty(spectrum.rawData)
                i = i+1;
                spectrum.lines{i} = '[data moved to data table]';
            end
        else
            warning('Multiple datasets. Only first one is used.');
        end
    end
end
fclose(file);

q = spectrum.rawData';

%% Energy calibration
if ~isempty(spectrum.calibrationEnergy)
    chanels = 0:length(q)-1;
    if length(spectrum.calibrationEnergy) == 1
        spectrum.E = chanels*spectrum.calibrationEnergy/spectrum.calibrationChannel;
    else
        dE = (spectrum.calibrationEnergy(2)-spectrum.calibrationEnergy(1))/(spectrum.calibrationChannel(2)-spectrum.calibrationChannel(1));
        m = spectrum.calibrationEnergy(1) - dE*spectrum.calibrationChannel(1);

        spectrum.E = dE*chanels+m;
    end
    doCorrections = true;
else
    spectrum.E = 0:length(q)-1;
    doCorrections = false;
end

%% Threshold check and peak time warning
if spectrum.countSlow>spectrum.countFast
    warning(['The count rate is higher in the slow channel than in the fast channel. '...
             'Check that the fast channel threshold is set correctly (it should probably be reduced)!']);
end

% if spectrum.serialNumber == 12455 && spectrum.peaktimeFast==400
% %     warning(['The fast channel peak time for the CdTe detector is set to 400 ns. '...
% %              'This has given problems before so it''s recommended to lower it to 100 ns!']);
% end

%% Normalizations
% Time
if ~isempty(spectrum.time) && ~isempty(spectrum.timeAcc) && ~isempty(spectrum.countFast) 
    % Corrects for noise in the fast channel at high count rates (nonparalyzable model)
    if ~isempty(spectrum.peaktimeFast) && spectrum.countFast/spectrum.timeAcc>1e5
        tCorrection = 1-(spectrum.countFast/spectrum.timeAcc)*spectrum.peaktimeFast*1e-9;
        spectrum.corrections = [spectrum.corrections 'fast channel dead time, '];
    else
        tCorrection = 1;
    end
    q = q/spectrum.time / tCorrection;
    spectrum.normalizations = [spectrum.normalizations '/s'];
end

% Source power
if ~isempty(spectrum.voltage) && ~isempty(spectrum.current)
    q = q/(spectrum.voltage*spectrum.current*1e-3);
    spectrum.normalizations = [spectrum.normalizations '/W'];
end

% Solid angle of the spectrometer
if ~isempty(spectrum.pinhole) && any(spectrum.pinhole) && ~isempty(spectrum.distance)
    spectrum.solidAngle = 2*pi*(1-1/sqrt(1+((spectrum.pinhole*1e-6/2)/spectrum.distance)^2)); %~area/dist^2
    q = q / spectrum.solidAngle;
    spectrum.normalizations = [spectrum.normalizations '/sr'];
end

% Save normalized data only
spectrum.dataNoCorr = q;

%% Corrections
% Only do corrections if energy calibration is made  
if doCorrections
    % Compensate for detection efficiency
    % SDD
    if spectrum.serialNumber == 13944 
        attLim = spectrum.E>=1; %attenuate only works for E>1
        qe = 1-attenuate(spectrum.E(attLim)*1e3, ones(1,length(spectrum.E(attLim))), 'Si', 2329, 500e-6, 'muEn');
        q(attLim) = q(attLim)./qe;
        spectrum.corrections = [spectrum.corrections 'detector QE, '];
        spectrum.detectorQE = qe;
    % CdTe (12455: CdTe 25 mm^2, 10092: CdTe 9 mm^2)
%     elseif spectrum.serialNumber == 12455 || spectrum.serialNumber == 10092 
%         attLim = spectrum.E>=1; %attenuate only works for E>1
%         qe = 1-attenuate(spectrum.E(attLim)*1e3, ones(1,length(spectrum.E(attLim))), 'CdTe', 5850, 1000e-6, 'muEn');
%         q(attLim) = q(attLim)./qe;
%         spectrum.corrections = [spectrum.corrections 'detector QE, '];
%         spectrum.detectorQE = qe;
%     else
        spectrum.detectorQE = 1;
    end
    
    % Data from getCommonMaterials.m
    % Compensate for absorption in air. 
    if ~isempty(spectrum.airDistance)
        air.name = 'Dry air';
        air.formulas = {'(N2)780840(O2)209460Ar9340(CO2)383Ne18.18He5.24(CH4)1.745Kr1.14(H2)0.55'};
        air.density = 1.2;
        q = attenuate(spectrum.E*1e3, q, air.formulas, air.density, -spectrum.airDistance, 'mu');
        spectrum.corrections = [spectrum.corrections 'air absorption, '];
    end

    % If vacuum tubes were used in the spectral measurement, compensate for absorption in the kapton windows  
    if ~isempty(spectrum.kaptonThickness)
        kapton.name = 'Kapton HN';
        kapton.formulas = {'C22N2O5H10'};
        kapton.density = 1420;
        q = attenuate(spectrum.E*1e3, q, kapton.formulas, kapton.density, -2*spectrum.kaptonThickness*1e-6, 'mu');
        spectrum.corrections = [spectrum.corrections 'kapton thickness'];
    end
end
if isempty(spectrum.corrections)
    spectrum.corrections = 'None';
end

% Save data with corrections
spectrum.data = q;


%% Plot
if doPlot
    [~,fName,fExt] = fileparts(fileName);
    figure;
    semilogy(spectrum.E,spectrum.data,'-b')
    if ~strcmp(spectrum.corrections,'None')
        hold on
        semilogy(spectrum.E,spectrum.dataNoCorr,'-r')
        legend('Corrected','Not corrected')
    end
    xlabel('Energy (keV)')
    ylabel(['ph' spectrum.normalizations])
    title(sprintf('File: %s\nCorrections: %s',[fName fExt],spectrum.corrections),'interpreter','none')
end

