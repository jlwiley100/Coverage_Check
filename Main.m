%Main

clear; clc;

%% PARAMETERS

% number of recievers
n_rx = 6;

% target folder in outputs folder
target_folder = '6_1000_80_1 14sp';

%% INITIALIZATION
success_count = 0;
fail_count = 0; 

%get sim data
output_folder = 'outputs/';
spec = loadSpecDat(strcat(output_folder, target_folder, "/"),n_rx);

res = 25;
latPerKm = 1/110.574;
latPer25Km = res*latPerKm;

lati = -90;

%% CALCULATION
while lati < (90 - latPer25Km)
    
    latNext = lati+latPer25Km;
    longes = GenerateGridPoints(lati,latNext,res);
    
    [si,fi] = CheckPointsInGrid(lati,latNext,longes,spec);
    success_count = success_count +si;
    fail_count = fail_count + fi;
    lati = latNext;
    
end

% Percent of coverage (%)
PercentCoverage = success_count/(success_count+fail_count) * 100;

%% OUTPUT
fprintf("Done! Percentage Coverage: %2.2f%%\n", PercentCoverage);