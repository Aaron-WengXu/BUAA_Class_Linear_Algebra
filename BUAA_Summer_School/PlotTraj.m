function PlotTraj(gnssPnt, gnssMeas,dirName)
    %% Plot positioning errors
    % Get ground truth locations
    GTxyz = zeros(3, size(gnssMeas.GtPos, 3));
    GTxyz(:,:) = gnssMeas.GtPos(1,:,:);

    % Get WLS-based estimates
    WLSxyz = gnssPnt.allXyzMMM(:,:);

    DeltaXyz = WLSxyz - GTxyz';

    figure;  
    subplot(3,1,1);
    plot(DeltaXyz(:,1),'m','linewidth',2);hold on;
    xlabel("Epoch (s)",'linewidth',2);
    ylabel("Error on X axis (m)",'linewidth',2);
    title("WLS-based Positioning Errors");

    subplot(3,1,2);
    plot(DeltaXyz(:,2),'m','linewidth',2);hold on;
    xlabel("Epoch (s)",'linewidth',2);
    ylabel("Error on Y axis (m)",'linewidth',2);
    
    subplot(3,1,3);
    plot(DeltaXyz(:,3),'m','linewidth',2);hold on;
    xlabel("Epoch (s)",'linewidth',2);
    ylabel("Error on Z axis (m)",'linewidth',2);

    % Plotting Trajectories
    latitudes = gnssPnt.allLlaDegDegM(:,1);
    longitudes = gnssPnt.allLlaDegDegM(:,2);
    
    figure1 = figure;
    % WLS
    plot(longitudes,latitudes,'m','linewidth',4);
    legend("WLS",'FontSize',20);
    xlabel("Longitude",'FontSize',20);
    ylabel("Latitude",'FontSize',20);
    axis tight;
    hold on;

    % MTV area
    I = imread([dirName '/MTV.png']); 
    axis([-122.5, -121.8, 37.3, 37.7]);
    h = image('XData',[-122.5, -121.8],'YData',[37.7,37.3],'CData',I);%note the latitude (y-axis) is flipped in vertical direction
    uistack(h,'bottom'); %move the image to the bottom of current stack
    
    figure;
    gx = geoaxes('Basemap','streets');
    geoplot(gx,latitudes,longitudes,'g','linewidth',4);
    geobasemap(gx,'streets')
       
    
%     In China, Open web map can not be accessed. If you cannot access open
%     street map, please comment the following codes
%     wm = webmap('OpenStreetMap')
%     
%     % Create the waitbar
%     h = waitbar(0, 'Please wait...');
%     % Plot the GPS coordinates on the web map
%     for k = 1:length(latitudes)
%         wmmarker(latitudes(k), longitudes(k));
%         % Update the waitbar
%         waitbar(k / length(latitudes), h, sprintf('Progress: %d%%', round(100 * k / length(latitudes))));
%     end
%     % Close the waitbar when done
%     close(h);

end