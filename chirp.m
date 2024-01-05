fSamp = 8000; %-Number of time samples per second
amp = 1;
dt = 1/fSamp;
tStart = 0;
tStop = 1.5;
tt = tStart:dt:tStop;
mu = -1000;
fzero = 2000;
phi = 2*pi*rand; %-- random phase

psi = (2*pi*f + 2*pi*fzero*tt + phi);

cc = real( 7.7*exp(j*psi) );
%soundsc( cc, fSamp ); %-- uncomment to hear the sound
plotspec( cc+j*1e-12, fSamp, 1600 ), colorbar, grid on