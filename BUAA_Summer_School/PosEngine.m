function gnssPnt = PosEngine(gnssMeas)
    % Initial location and clock offset guess
    xo = [-1509706.868, 6195107.314, 149731.63, 0]';

    % number of epochs
    N = length(gnssMeas.Epoch);

    % Allocate space for user locations in ECEF
    gnssPnt.allXyzMMM = zeros(N,3)+NaN;
    % Allocate space for user locations in LLA
    gnssPnt.allLlaDegDegM = zeros(N,3)+NaN;
    % Allocate space for user clock offset
    gnssPnt.allBcMeters = zeros(N,1)+NaN;

    % Main loop
    for i = 1:N
        % Find valid satellites at the current epoch
        iValid = find(isfinite(gnssMeas.PrM(i,:))); %index into valid svid
        svid = gnssMeas.PRN(iValid)';
        
        % Check inputs
        numVal = length(svid);
        % If we don't have enough visible satellites, we will skip to next
        % epoch
        if numVal < 4
          continue;
        end

        % Get pseuodrange measurements at the current epoch
        prM = gnssMeas.PrM(i,iValid)';
        prSigmaM= gnssMeas.PrSigmaM(i,iValid)';

        % Get satellite positions
        SvPos = gnssMeas.SvPos(:,:,i,iValid);

        % Prepare the input variables
        prs = [svid, prM, prSigmaM];

        % Use WLS to solve the positioning problem
        dxHat = WlsPos(xo, prs, SvPos);
        xo = xo + dxHat;

        % Pack ECEF positioning results of WLS
        gnssPnt.allXyzMMM(i,:) = xo(1:3);

        %Calculate the geodetic latitude and longitude of the user
        llaDegDegM = Xyz2Lla(xo(1:3)');   
        
        % Pack lla positioning results of WLS
        gnssPnt.allLlaDegDegM(i,:) = llaDegDegM;
        
        % Pack timing results of WLS
        gnssPnt.allBcMeters(i) = xo(4);

    end
end