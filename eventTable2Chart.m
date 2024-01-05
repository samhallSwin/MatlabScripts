function eventTable2Chart(eventList, simStartTime, simStopTime, sampleTime)
    simStartTime.TimeZone = 'UTC';
    simStopTime.TimeZone = 'UTC';

    for i = 1:length(eventList)
        startTimes(i) = eventList{i}.StartTime
        endTimes(i) = eventList{i}.EndTime;
    end;
    %timeDifference = simStopTime - simStartTime;
    %totalTime = seconds(timeDifference);
    
    startTimesSamp = seconds(startTimes - simStartTime)/sampleTime;
    stopTimesSamp = seconds(endTimes - simStartTime)/sampleTime;

    totalTime = seconds(simStopTime - simStartTime)/sampleTime;

    % Create a logical matrix indicating the presence of events at each time point
    numEvents = height(eventList);
    eventMatrix = false(1, totalTime);
    eventMatrix=eventMatrix*255;
    
    for i = 1:numEvents
        eventMatrix(1, startTimesSamp(i):stopTimesSamp(i)) = 1;
    end
    
    

    % Create a heatmap
    figure;
    %heatmap(eventMatrix, 'Colormap', 'hot', 'ColorLimits', [0 1], 'YLabel', 'Event', 'XLabel', 'Time', 'Title', 'Event Heatmap');
    heatmap(eventMatrix);

end