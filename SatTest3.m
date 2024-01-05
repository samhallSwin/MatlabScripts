clear;
startTime = datetime(2023,7,10,22,0,0);              % 19 August 2020 8:55 PM UTC
stopTime = startTime + hours(6);                       % 20 August 2020 8:55 PM UTC
sampleTime = 1;                                      % seconds
sc = satelliteScenario(startTime,stopTime,sampleTime);
satelliteScenarioViewer(sc);

tleFile = "NovaSar.tle"; 
sat1 = satellite(sc,tleFile)

gimbalSat1Tx = gimbal(sat1, ...
    "MountingLocation",[0;1;2]);  % meters
gimbalSat1Rx = gimbal(sat1, ...
    "MountingLocation",[0;-1;2]); % meters

sat1Rx = receiver(gimbalSat1Rx, ...
    "MountingLocation",[0;0;1], ...      % meters
    "GainToNoiseTemperatureRatio",3, ... % decibels/Kelvin
    "RequiredEbNo",4);                   % decibels

gaussianAntenna(sat1Rx, ...
    "DishDiameter",0.5);    % meters

sat1Tx = transmitter(gimbalSat1Tx, ...
    "MountingLocation",[0;0;1], ...   % meters
    "Frequency",30e9, ...             % hertz
    "Power",15);                      % decibel watts

gaussianAntenna(sat1Tx, ...
    "DishDiameter",0.5);    % meters

latitude = -33.7974039;        % degrees
longitude = 151.1768208;       % degrees
gs1 = groundStation(sc, ...
    latitude, ...
    longitude, ...
    "Name","Ground Station 1");

latitude = 6.5244;          % degrees
longitude = 3.3792;         % degrees
gs2 = groundStation(sc, ...
    latitude, ...
    longitude, ...
    "Name","Ground Station 2");

gimbalGs1 = gimbal(gs1, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters

gimbalGs2 = gimbal(gs2, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters

gs1Tx = transmitter(gimbalGs1, ...
    "Name","Ground Station 1 Transmitter", ...
    "MountingLocation",[0;0;1], ...           % meters
    "Frequency",2.1e9, ...                     % hertz
    "Power",36);                              % decibel watts

gs2Tx = transmitter(gimbalGs2, ...
    "Name","Ground Station 1 Transmitter", ...
    "MountingLocation",[0;0;1], ...           % meters
    "Frequency",2.1e9, ...                     % hertz
    "Power",36);   

gaussianAntenna(gs1Tx, ...
    "DishDiameter",2.4); % meters

gaussianAntenna(gs2Tx, ...
    "DishDiameter",2.4); % meters

pointAt(gimbalGs1,sat1);
pointAt(gimbalSat1Rx,gs1);

pointAt(gimbalGs2,sat1);

lnk1 = link(gs1Tx,sat1Rx);
linkIntervals(lnk1)

[e, time] = ebno(lnk1);
margin1 = e - sat1Rx.RequiredEbNo;

pointAt(gimbalSat1Rx,gs2);

lnk2 = link(gs2Tx,sat1Rx);
linkIntervals(lnk2)

[e, time] = ebno(lnk2);
margin2 = e - sat1Rx.RequiredEbNo;

margin1(margin1 < -10e6) = 0;
margin2(margin2 < -10e6) = 0;
marginSum = margin1 + abs(margin2);

plot(time,marginSum,"LineWidth",2);
xlabel("Time");
ylabel("Link Margin (dB)");
grid on;

