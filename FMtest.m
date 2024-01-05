fSamp = 4000; %-Number of time samples per second
dt = 1/fSamp;
tStart = 0;
tStop = 2;
tt = tStart:dt:tStop;
f_c = 1000;
A = 1;
alpha = 500;
beta = 3;
gamma = (-pi/1.6);
omega_t = (2*pi*f_c + 2*pi*alpha*cos(2*pi*beta*tt+gamma));
%int((x^2)); 
psy_t = (2*pi*f_c*tt)+(((alpha)/beta)*sin(2*pi*beta*tt+gamma)); %psy_t is the integral of omega_t and is the argument to the cosine of the signal
cc = real( A*exp(j*psy_t));
%cc = A*cos(psy_t);
%figure, plot(cc,tt);
%soundsc( cc, fSamp ); %-- uncomment to hear the sound
plotspec( cc, fSamp, 90 ), colorbar, grid on %-- with negative frequencies
orient('tall');
print('FM spectrogram','-dpng');