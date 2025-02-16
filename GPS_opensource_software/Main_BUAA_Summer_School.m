%% Sample codes of the Weighted Least Squares Algorithms for GPS positioning
clc;
clear;

%% Set data directory
dirName ='../data/GSDC/MTV/2020-05-14-US-MTV-1';
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


