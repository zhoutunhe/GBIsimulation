% fba.m
%
% DESCRIPTION:
%	Fourier-based analysis method for PSC
%
% CALL:
% 	[A,B,P] = fba(data,periods)
%	
% 	data: the PSCs must be the last dimension of data (e.g. data(y,x,psc))
% 	periods: number of periods
%
% 	A: absorption data 
%	B: dark-field data
% 	P: dpc data
%
% NICE TO HAVE:
%	processing 1D/2D/3D data (Peter)
%
% UPDATES:
%	30.07.2010 (Peter): renamed the function. old name: phaseana.m 
%	08.03.2010 (Thomas): fba can now use 1D and 2D data
%	01.01.2010 (Peter): first version 

function [A,B,P] = FBA(data,periods)

if nargin < 2,
    periods = 1;
end

% distinguish between 1D & 2D data
if ndims(data) == 2
    fdata = fft(data,[],2);
    A = abs(fdata(:,1))/size(data,2);
    B = abs(fdata(:,periods+1))*2/size(data,2);
    P = angle(fdata(:,periods+1));
else
    fdata = fft(data,[],3);
    A = abs(fdata(:,:,1))/size(data,3);
%     A = mean(data,3);
    B = abs(fdata(:,:,periods+1))*2/size(data,3);
    P = angle(fdata(:,:,periods+1));
end

% plot(abs(squeeze(fdata)))


