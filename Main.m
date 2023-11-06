%Main

clear; clc;

%% PARAMETERS

% incidence angle constraint for high RCG
angle = 60;

% number of recievers
n_rx = 9;

% target folder in outputs folder
target_folderL5 = strcat(num2str(n_rx), '_400_80_1_L5');
target_folderL1 = strcat(num2str(n_rx), '_400_80_1_L1');

%% INITIALIZATION
missedNum = 1;

success_count = 0;
fail_count = 0; 

% get sim data
output_folder = 'outputs/';
specL5 = loadSpecDat(strcat(output_folder, target_folderL5, "/"), n_rx, "L5");
specL1 = loadSpecDat(strcat(output_folder, target_folderL1, "/"), n_rx, "L1");
spec = [specL5; specL1];

spec = sortrows(spec, 1);

res = 25;
latPerKm = 1/110.574;
latPer25Km = res*latPerKm;

lati = -90;

missingSpecsTot = zeros(length(spec),2);

%% CALCULATION
while lati < (90 - latPer25Km)
    
    latNext = lati+latPer25Km;
    longes = GenerateGridPoints(lati,latNext,res);
    
    [si,fi, missingSpecs] = CheckPointsInGrid(lati,latNext,longes,spec);
    if ~isempty(missingSpecs)
        missingSpecsTot(missedNum:missedNum + length(longes)-2,:) = missingSpecs;
        missedNum = missedNum+length(longes)-1;
    end
    success_count = success_count +si;
    fail_count = fail_count + fi;
    lati = latNext;
    
end

% Percent of coverage (%)
PercentCoverage = success_count/(success_count+fail_count) * 100;

%% OUTPUT

idxes = find(missingSpecsTot(:,1));
actualMissingSpecs = zeros(length(idxes),2);
for m = 1:1:length(idxes)
    actualMissingSpecs(m,:) = [missingSpecsTot(idxes(m),1),missingSpecsTot(idxes(m),2)];
end

fprintf("Done! Percentage Coverage of %2.0f Rx: %2.2f%%\n", n_rx, PercentCoverage);

geoplot(spec(:,1), spec(:,2), '.', 'MarkerSize', 1, 'Color', [0 0 1])
hold on
geoplot(actualMissingSpecs(:,1), actualMissingSpecs(:,2), '.', 'MarkerSize', 1, 'Color', [1 0 0])