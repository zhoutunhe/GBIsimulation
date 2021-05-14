function img = addNoise(img, pixelSize, NPS, noiseScale, extraNoise)
%Adds gaussian noise with noise power spectrum NPS*noiseScale to the image
%img
%img is the image, a matrix of pixel values.
%pixelSize is the distance between pixels, either as a single value or a
%vector [dx dy], with the size in x- and y-direction
%NPS is a function taking spatial frequency as input and returning the
%noise power spectrum at that frequency.
%noiseScale is an optional scaling of the NPS. NPS*noiseScale should be of
%the same dimension (have the same unit) as img.^2. The variance (std^2)
%will thus be proportional to noiseScale.
%extraNoise is the variance of an additional gaussian uncorrelated noise
%source, e.g. readout noise.

if nargin < 4
    noiseScale = 1;
end
if nargin < 5
    extraNoise = 0;
end
if numel(pixelSize) == 1
    pixelSize(2) = pixelSize(1);
end

[Ny, Nx] = size(img); %number of pixels in x- and y-direction
du = 1/Nx/pixelSize(1);  %spatial frequency increment in x-direction
dv = 1/Ny/pixelSize(2);  %spatial frequency increment in y-direction
u = (-floor(Nx/2):floor((Nx-1)/2))*du; %frequency in x-direction
v = (-floor(Ny/2):floor((Ny-1)/2))*dv; %frequency in y-direction
[U, V] = meshgrid(u,v);
W = sqrt(U.^2+V.^2); %radial frequency
nps = sqrt(NPS(W)*noiseScale + extraNoise); %The square root of the noise power spectrum

noise = randn(size(img));
noise = ifft2(fft2(noise).*ifftshift(nps));

img = img+noise;