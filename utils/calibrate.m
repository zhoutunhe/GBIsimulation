%Assigns energies to channel 1:maxChannel with linear interpolation or
%extrapolation with the two closest points.
function energies = calibrate(channel, energy, maxChannel)
[channel permutation] = sort(channel);
energy = energy(permutation);
if ~issorted(energy)
    warning(['Calibration error. Energy should be an increasing'...
        'function of channel']);
end
if length(channel) == 1
    channel = [1 channel];
    energy = [0 energy];
    warning('Only one calibration point. Assuming energy=0 at channel 1.');
end
energies = zeros(1,maxChannel);
for c = 1:length(energy)-1
    if c==1
        if c == length(energy)-1
            i = 1:maxChannel;
        else
            i = 1:channel(2);
        end
    elseif  c == length(energy)-1
        i = channel(c):maxChannel;
    else
        i = channel(c):channel(c+1);
    end 
    energies(i) = energy(c) + (i-channel(c))*(energy(c+1)-energy(c))/...
        (channel(c+1)-channel(c));
end
