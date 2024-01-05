clear;
startTime = datetime(2023,7,11,6,0,0);              % 19 August 2020 8:55 PM UTC
stopTime = startTime + hours(6);                       % 20 August 2020 8:55 PM UTC
sampleTime = 1;                                      % seconds
sc = satelliteScenario(startTime,stopTime,sampleTime);
satelliteScenarioViewer(sc);

tleFile = "NovaSar.tle";
sat = satellite(sc,"Sat3.tle");

sat1=sat(3);
sat2=sat(2);
sat3=sat(1);

gimbalSat1Rx = gimbal(sat1, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat2Rx = gimbal(sat2, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat3Rx = gimbal(sat3, ...
    "MountingLocation",[0;-1;2]); % meters
gimbalSat1Tx = gimbal(sat1, ...
    "MountingLocation",[0;1;2]);  % meters
gimbalSat2Tx = gimbal(sat2, ...
    "MountingLocation",[0;1;2]);  % meters
gimbalSat3Tx = gimbal(sat3, ...
    "MountingLocation",[0;1;2]);  % meters

sat1Rx = receiver(gimbalSat1Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

sat2Rx = receiver(gimbalSat2Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

sat3Rx = receiver(gimbalSat3Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

gaussianAntenna(sat1Rx, ...
    "DishDiameter",0.5);    % meters

gaussianAntenna(sat2Rx, ...
    "DishDiameter",0.5);    % meters

gaussianAntenna(sat3Rx, ...
    "DishDiameter",0.5);    % meters

sat1Tx = transmitter(gimbalSat1Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",30e9, ...             % hertz
    "Power",15);                      % decibel watts
sat2Tx = transmitter(gimbalSat2Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",27e9, ...             % hertz
    "Power",15);                      % decibel watts

sat3Tx = transmitter(gimbalSat3Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",27e9, ...             % hertz
    "Power",15);                      % decibel watts

gaussianAntenna(sat1Tx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat2Tx, ...
    "DishDiameter",0.5);    % meters
gaussianAntenna(sat3Tx, ...
    "DishDiameter",0.5);    % meters

latitude = -33.7974039;        % degrees
longitude = 151.1768208;       % degrees
gs1 = groundStation(sc, ...
    latitude, ...
    longitude, ...
    "Name","Ground Station");

gimbalGs1 = gimbal(gs1, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters

gs1Tx = transmitter(gimbalGs1, ...
    "Name","Ground Station 1 Transmitter", ...
    "MountingLocation",[0;0;1], ...           % meters
    "Frequency",2.1e9, ...                     % hertz
    "Power",36);                              % decibel watts

gaussianAntenna(gs1Tx, ...
    "DishDiameter",2.4); % meters



pointAt(gimbalGs1,sat1);
pointAt(gimbalSat1Rx,gs1);

lnk(1) = link(gs1Tx,sat1Rx);
linkIntervals(lnk(1))

figure
[e, time] = ebno(lnk(1));
margin(1,:) = e - sat1Rx.RequiredEbNo;
plot(time,margin,"LineWidth",2);
xlabel("Time");
ylabel("Link Margin (dB)");
grid on;

pointAt(gimbalGs1,sat2);
pointAt(gimbalSat2Rx,gs1);
pointAt(gimbalSat2Tx,sat1);
pointAt(gimbalSat1Rx,sat2);

lnk(2) = link(gs1Tx,sat2Rx, sat2Tx, sat1Rx);
linkIntervals(lnk(2))

[e, time] = ebno(lnk(2));
margin(2,:) = e - sat2Rx.RequiredEbNo;



pointAt(gimbalGs1,sat3);
pointAt(gimbalSat3Rx,gs1);
pointAt(gimbalSat3Tx,sat1);
pointAt(gimbalSat1Rx,sat3);

lnk(3) = link(gs1Tx,sat3Rx, sat3Tx, sat1Rx);
%lnk(3) = link(sat3Tx, sat1Rx);
linkIntervals(lnk(3))

[e, time] = ebno(lnk(3));
margin(3,:) = e - sat3Rx.RequiredEbNo;

pointAt(gimbalGs1,sat3);
pointAt(gimbalSat3Rx,gs1);
pointAt(gimbalSat3Tx,sat2);
pointAt(gimbalSat2Rx,sat3);
pointAt(gimbalSat2Tx,sat1);
pointAt(gimbalSat1Rx,sat2);

lnk(4) = link(gs1Tx,sat3Rx, sat3Tx, sat2Rx, sat2Tx, sat1Rx);
linkIntervals(lnk(4))

[e, time] = ebno(lnk(4));
margin(4,:) = e - sat1Rx.RequiredEbNo;

pointAt(gimbalGs1,sat2);
pointAt(gimbalSat2Rx,gs1);
pointAt(gimbalSat2Tx,sat3);
pointAt(gimbalSat3Rx,sat2);
pointAt(gimbalSat3Tx,sat1);
pointAt(gimbalSat1Rx,sat3);

lnk(5) = link(gs1Tx,sat2Rx, sat2Tx, sat3Rx, sat3Tx, sat1Rx);
linkIntervals(lnk(5))

[e, time] = ebno(lnk(5));
margin(5,:) = e - sat1Rx.RequiredEbNo;

figure
subplot(1,2,1);
plot(time,margin,"LineWidth",2);
xlabel("Time");
ylabel("Link Margin (dB)");
grid on;
legend({'Direct to Sat1','via Sat2','via Sat3', 'via Sat3 then sat2','via Sat2 then sat3'})

%margin(margin < -10e6) = 0;

marginSumInt1 = max(margin(1,:),margin(2,:));
marginSumInt2 = max(marginSumInt1,margin(3,:));
marginSumInt3 = max(marginSumInt2,margin(4,:));
marginSum = max(marginSumInt3,margin(5,:));
%eSum = e(1) + e(2) + e(3) + e(4) + e(5);
% %lnk = lnk1 + lnk2 + lnk3 + lnk4 + lnk5;
% 
marginSum(marginSum <= 0) = -inf;
subplot(1,2,2);
plot(time,marginSum,"LineWidth",2);
xlabel("Time");
ylabel("Link Margin (dB)");
grid on;

