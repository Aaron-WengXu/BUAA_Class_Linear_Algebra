function [header,C] = ReadRawCsv(dirName, fileName)
    %make extended file name
    if dirName(end)~='/'
        dirName = [dirName,'/']; %add /
    end    
    rawCsvFile = [dirName,fileName];
    fprintf('\nReading file %s\n',rawCsvFile)

    % read header row:
    fid = fopen(rawCsvFile);
    if fid<0
        error('file ''%s'' not found',rawCsvFile);
    end
    headerString = fgetl(fid);
    header=textscan(headerString,'%s','Delimiter',',');
    header = header{1}; %this makes header a numFieldsx1 cell array

    % read data lines:
    formatSpec='%d32 %f %f %f %f %f %f %f %f %f';
    C = textscan(fid,formatSpec,'Delimiter',',','EmptyValue',NaN);
    fclose(fid);
    fprintf('\nCompletely loaded file %s\n',rawCsvFile)
end