%Main

clear; clc;

%% PARAMETERS

% incidence angle constraint for high RCG
angle = 60;

% number of recievers
n_rx = 10;

% target folder in outputs folder
target_folderL5 = strcat(num2str(n_rx), '_500_80_1_L5');
target_folderL1 = strcat(num2str(n_rx), '_500_80_1_L1');

%% INITIALIZATION
success_count = 0;
fail_count = 0; 

% get sim data
output_folder = 'outputs/';
specL5 = loadSpecDat(strcat(output_folder, target_folderL5, "/"), n_rx, "L5");
%specL1 = loadSpecDat(strcat(output_folder, target_folderL1, "/"), n_rx, "L1");
%spec = [specL5; specL1];
spec = specL5;

spec = sortrows(spec, 1);

res = 25;
latPerKm = 1/110.574;
latPer25Km = res*latPerKm;

lati = -90;

missingSpecsTot = zeros(length(spec),2);

%% CALCULATION

% TODO: Replace checkpointsingrid function with Chris's implementation
failgrid = [[];[]];
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

fprintf("Done! Percentage Coverage of %2.0f Rx: %2.2f%%\n", n_rx, PercentCoverage);

%geoplot(spec(:,1), spec(:,2), '.', 'MarkerSize', 1, 'Color', [0 0 1])
%hold on
%geoplot(failgrid(1,:), failgrid(2,:), '.', 'MarkerSize', 1, 'Color', [1 0 0])