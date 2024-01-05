clear;
startTime = datetime(2023,7,10,22,0,0);              % 19 August 2020 8:55 PM UTC
stopTime = startTime + hours(6);                       % 20 August 2020 8:55 PM UTC
sampleTime = 1;                                      % seconds
sc = satelliteScenario(startTime,stopTime,sampleTime);
satelliteScenarioViewer(sc);

tleFile = "Walker.tle";
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
    "DishDiameter",0.1);    % meters

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
    "Name","Ground Station");

gimbalGs1 = gimbal(gs1, ...
    "MountingAngles",[0;180;0], ... % degrees
    "MountingLocation",[0;0;-5]);   % meters

gs1Tx = transmitter(gimbalGs1, ...
    "Name","Ground Station 1 Transmitter", ...
    "MountingLocation",[0;0;1], ...           % meters
    "Frequency",433e6, ...                     % hertz
    "Power",36);                              % decibel watts

gaussianAntenna(gs1Tx, ...
    "DishDiameter",2.4); % meters

pointAt(gimbalGs1,sat1);
pointAt(gimbalSat1Rx,gs1);

lnk = link(gs1Tx,sat1Rx);
linkIntervals(lnk)
play(sc);

[e, time] = ebno(lnk);
margin = e - sat1Rx.RequiredEbNo;
plot(time,margin,"LineWidth",2);
xlabel("Time");
ylabel("Link Margin (dB)");
grid on;

