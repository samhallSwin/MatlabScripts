% Define file path and duration
tle_file = "leoSatelliteConstellation4.tle"; % Replace with actual path
duration = 6 * 60; % Duration in minutes

% Read satellites from TLE file
satellites = tleread(tle_file);

% Define ground station coordinates
ground_station = [-37.8667, 144.9556]; % Melbourne, Australia (example)

% Initialize connection matrix
connection_matrix = zeros(length(satellites), length(satellites) + 1, duration);

% Loop through each minute
for t = 1:duration
% Update satellite positions
[~, keplerianElements] = tleread(tle_file); % Assuming you have tleRead now
positions = twoBodyPropagator(keplerianElements, t * 60);

  % Calculate visibility for each satellite-ground station link
  visible_ground = satpos(keplerianElements, ground_station, t * 60);

  % Calculate visibility for each satellite-satellite link
  visible_satellites = [];
  for i = 1:length(satellites)
    for j = i+1:length(satellites)
      visible_satellites(end+1) = satlink(keplerianElements(i,:), ...
                                          keplerianElements(j,:), ...
                                          ground_station, t * 60);
    end
  end

  % Update connection matrix
  connection_matrix(:, 1, t) = visible_ground;
  connection_matrix(:, 2:end, t) = visible_satellites;
end

% Analyze and visualize the connection matrix as needed
% ...

% Example: Plot the number of connections each satellite has
sum_connections = sum(connection_matrix, 2);
figure; bar(1:length(satellites), sum_connections(2:end));
title('Number of Connections per Satellite (excluding ground)');