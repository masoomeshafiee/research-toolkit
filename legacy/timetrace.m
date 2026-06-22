function result = timetraceFinal
    spotAdress = uigetfile('*.csv','Pick your spot file');
    spot = csvread(spotAdress);
    plot(spot(:,1),spot(:,5))
    xlabel('Frame number');
    ylabel('Intensity');
    title('initial plot')
    startPoint = inputdlg('set the start time point', 'frame number choice');
    startPoint = str2num(startPoint{1});
    stopPoint = inputdlg('set the stop time point', 'frame number choice');
    stopPoint = str2num(stopPoint{1});
    frameNumber= spot(startPoint : stopPoint, 1) - startPoint;
    y = spot(startPoint: stopPoint, 5);
    plot(frameNumber, y)
    %ax = gca;
    %ax.YAxis.Exponent = 4; % Shifts the decimal point 4 places to the left
    %ax.YAxis.TickLabelFormat = '%.1f';
    xlabel('Frame number');
    ylabel('Intensity');
    title('Mrc1')
   
end