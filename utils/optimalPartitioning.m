%Given N (number of intervals in partitioning), w_i (weight), e_i (energy),
%optimalPartitioning calculates the s_i (1\leq i\leq N) (starts) and
%c_i (1\leq i < N) (centers) that minimizes:
%sum_{i=1}^N sum_{j=s_i}^{s_{i+1}} w_j(e_j-c_i)^2
%e_i is asumed to be strictly monotonic.
% More easily explained: If weight(i) is the number of photons of energy
%energy(i) optimalPartitioning will calculate a way to divide the interval
%[energy(1), energy(end)] into N subintervals so that the average square
%of the difference in energy between the photons and the center energy in
%the interval which contains the photon is minimized.
% This is a good way of choosing which energies out of a spectrum to do a
%full simulation of.
% starts is an N-1 element row vector containing the start indices of the
%intervals and ending with the 1+the end index of the last interval.
% centers is an N element row vector with the weighted average energy within
%each interval
% weights is an N element row vector with the total weight within each
%interval
function [starts, centers, weights] = optimalPartitioning(N, energy, weight)
L = length(weight);
if N > sum(weight>0)
    N = sum(weight>0);
end
psum = [0 cumsum(weight)]; %prefix sum
wsum = [0 cumsum(weight.*energy)]; %weighted prefix sum
w2sum = [0 cumsum(weight.*energy.^2)]; %weighted^2 prefix sum

optimal = inf*ones(N+1,L+1);
previous = optimal;
optimal(1) = 0;
for i = 2:N+1
    for e = 1:L+1
        for b = 1:e-1
            center = (wsum(e)-wsum(b))/(psum(e)-psum(b));
            momentum = w2sum(e)-w2sum(b) - (psum(e)-psum(b))*center^2;
            if optimal(i-1,b)+momentum < optimal(i,e)
                optimal(i,e) = optimal(i-1,b)+momentum;
                previous(i,e) = b;
            end
        end
    end
end

starts = ones(1,N+1);
centers = ones(1,N);
starts(N+1) = L+1;
for i = N:-1:1
    starts(i) = previous(i+1,starts(i+1));
    centers(i) = (wsum(starts(i+1))-wsum(starts(i)))/...
        (psum(starts(i+1))-psum(starts(i)));
end
%sum of weight over each interval
weights = psum(starts(2:end))-psum(starts(1:end-1));