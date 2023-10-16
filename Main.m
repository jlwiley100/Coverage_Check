%Main

%number of recievers
n_rx = 6;

%initialization
success_count = 0;
fail_count = 0; 
lastSpecIndex = 0;

%get sim data
output_folder = '6_1000_80_6_45/';
spec = loadSpecDat(output_folder,n_rx);

res = 25;
latPerKm = 1/110.574;
latPer25Km = res*latPerKm;

lati = -90;

% run through each lattitude band of 25 km
while lati < (90 - latPer25Km)
    
    latNext = lati+latPer25Km;
    % find the longitude bands at that lattitude
    longes = GenerateGridPoints(lati,latNext);
    
    %find how many grid spaces were sucess and failures
    [si,fi,lastSpecIndex] = CheckPointsInGrid(lati,latNext,longes,spec,lastSpecIndex);
    success_count = success_count +si;
    fail_count = fail_count + fi;
    lati = latNext;
    
end

PercentCoverage = success_count/(sucess_count+fail_count);