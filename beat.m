amp=10;
fc=1024;
phic = 2*pi*rand;
fDelta = 16;
phiDelta= 2*pi*rand;
tStart=0;
tStop=5;
fSamp = 8000;
tt= tStart:(1/fSamp):tStop;
xx=amp*cos(2*pi*fc*tt+phic).*cos(2*pi*fDelta*tt+phiDelta);
plotspec( xx, fSamp, 875 ), colorbar, grid on