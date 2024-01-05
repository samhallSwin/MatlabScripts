f=4000;
T=1/f;
tt=-T:(1/(f*25)):T;
M=6; D = 26;
A1=19;
A2 = A1*1.2;
tm1=(37.2/M)*T;
tm2=-(41.3/D)*T;
x1=A1*cos(2*f*pi*(tt-tm1));
x2=A2*cos(2*f*pi*(tt-tm2));
x3=x1+x2;
subplot(3,1,1);
plot(tt,x1);
subplot(3,1,2);
plot(tt,x2);
subplot(3,1,3);
plot(tt,x3);

n1=mod(tm1,T);
n2=mod(tm2,T);
(n1/T)*2*pi
(n2/T)*2*pi