%% Sample codes of the Weighted Least Squares Algorithms for GPS positioning
clc;
clear;

%% Set data directory
dirName ='../Data_BUAA/GSDC/MTV/2020-06-05-US-MTV-2';
fileName = 'Measurements.csv';

%% Load data from .csv files
[header,C] = ReadRawCsv(dirName, fileName);
% pack data into gnssRaw structure
gnssRaw = PackGnssRaw(C,header);
% Seperate data of different epochs
gnssMeas = ProcessGnssData(gnssRaw);

%% WLS positioning engine
gnssPnt = PosEngine(gnssMeas);


%% Results plotting
PlotTraj(gnssPnt, gnssMeas, dirName);


