function dxHat = WlsPos(xo, prs, SvPos)
    % Use WLS to solve GNSS positioning problem
    % Inputs: xo    --- User state approximation (for linearization)
    %         prs   --- Pseudorange measurements (including visible satellites, pseudoranges, pseudorange uncertainty)
    %         SvPos --- Satellite positions

    % Outputs: dxHat --- Displacement from the approximate user state to the estimate one

    % Get approximate user location
    xyz0 = xo(1:3);
    % Get approximate clock offset
    bc = xo(4);
    % Get number of visible satellites
    numVal = length(prs(:,1));
    % Get satellite positions
    SvXyz = zeros(3, numVal);
    SvXyz(:,:) = SvPos(1,:,:);
    % Get pseudoranges
    PrM = prs(:, 2);
    % Get pseudorange rates
    PrSigmaM = prs(:, 3);
    % Compute weighting matrix
    Wpr = diag(1./PrSigmaM);

    % Initialize the displacement from the approximate user state to the estimate one
    dxHat=zeros(4,1);
    % Initialize the user state change for each iteration
    dx = dxHat+inf;
    % Set the maximum iteration times
    whileCount=0;
    maxWhileCount=100; 
    while norm(dx) > 20 % the threshold 20 is set according to Google's codes
        whileCount=whileCount+1;
        assert(whileCount < maxWhileCount,...
            'while loop did not converge after %d iterations',whileCount);

        % Ccalculate line of sight vectors from satellite to xo
        v = xyz0(:)*ones(1,numVal) - SvXyz;
        % Normalization
        range = sqrt( sum(v.^2) );
        v = v./(ones(3,1)*range);

        % Calculate Pseudorange Residual
        dPrM = PrM - (range(:) + bc);

        % Construct Jacobian Matrix
        G = [v', ones(numVal,1)]; % G = [unit vector,1]

        % WLS
        dx = pinv(Wpr*G)*Wpr*dPrM;
        % Accumulate user state displacement
        dxHat = dxHat+dx;
        % Update approximate user state
        xyz0 = xyz0(:)+dx(1:3);
        bc = bc+dx(4);% receiver clock bias
    end
end