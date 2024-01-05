fSamp = 4000; %-Number of time samples per second

dt = 1/fSamp;

tStart = 0;

tStop = 2;

tt = tStart:dt:tStop;

 

f_c=1000;

alpha=10;

beta=3;

w = 2*pi*f_c+alpha*cos(2*pi*beta.*tt);

 

AA=1;

cc=AA*cos(w.*tt);

plotspec( cc+j*1e-12, fSamp, 200 ), colorbar, grid on 