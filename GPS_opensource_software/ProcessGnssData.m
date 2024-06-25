function gnssMeas = ProcessGnssData(gnssRaw)
    % measurements stored in gnssRaw are formated in the same column
    % we need to seperate them per time

    % All the sv ids found in gnssRaw
    gnssMeas.PRN = unique(gnssRaw.PRN)'; 
    M = length(gnssMeas.PRN);

    % Number of epochs in the measurements
    gnssMeas.Epoch = unique(gnssRaw.Epoch)';
    N = length(gnssMeas.Epoch);

    % Initialize Pseudoranges
    gnssMeas.PrM = zeros(N,M)+NaN;

    % Initialize Pseudorange Uncertainty
    gnssMeas.PrSigmaM = zeros(N,M)+NaN;

    % Initialize Satellite Positions
    gnssMeas.SvPos = zeros(1,3,N,M)+NaN;

    % Initialize Ground Truth User Positions
    gnssMeas.GtPos = zeros(1,3,N)+NaN;

    %Now pack these measurements into the NxM matrices
    for i = 1:N % i is the index of epochs
        % Find the index of measurements at the current epoch
        J = find(gnssMeas.Epoch(i) == gnssRaw.Epoch);
        for j = 1:length(J) 
            % k is the index of visible satellites
            k = find(gnssMeas.PRN==gnssRaw.PRN(J(j)));

            % Pack up pseudorange measurements 
            gnssMeas.PrM(i,k) = gnssRaw.PrM(J(j));

            % Pack up pseudorange measurement uncertainty
            gnssMeas.PrSigmaM(i,k) = gnssRaw.PrSigmaM(J(j));

            % Pack up satellite positions
            gnssMeas.SvPos(:,:,i,k) = [gnssRaw.SvX(J(j)), gnssRaw.SvY(J(j)), gnssRaw.SvZ(J(j))];

            % Pack up ground truth user locations
            gnssMeas.GtPos(:,:,i) = [gnssRaw.GTx(J(j)), gnssRaw.GTy(J(j)), gnssRaw.GTz(J(j))];
        end
    end
end