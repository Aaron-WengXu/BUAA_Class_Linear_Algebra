function gnssRaw = PackGnssRaw(C,header)
    %% pack data into gnssRaw
    assert(length(C)==length(header),...
        'length(C) ~= length(header). This should have been checked before here')
    gnssRaw = [];
    
    %pack data into vector variables of the class 'gnssRaw', if the fields are not NaNs
    for j = 1:length(header)
        if any(isfinite(C{j})) %not all NaNs
            eval(['gnssRaw.',header{j}, '=C{j};']);
        end
    end

end