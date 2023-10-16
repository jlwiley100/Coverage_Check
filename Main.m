%Main

%number of recievers
n_rx = 6;

%initialization
success_count = 0;
fail_count = 0; 

missedNum =1;

%get sim data
output_folder = '6_1000_80_6_45/';
spec = loadSpecDat(output_folder,n_rx);

res = 50;
latPerKm = 1/110.574;
latPer25Km = res*latPerKm;

lati = -90;

missingSpecsTot = zeros(length(spec),2);

while lati < (90 - latPer25Km)
    
    latNext = lati+latPer25Km;
    longes = GenerateGridPoints(lati,latNext);
    
    [si,fi,missingSpecs] = CheckPointsInGrid(lati,latNext,longes,spec);
    if ~isempty(missingSpecs)
        missingSpecsTot(missedNum:missedNum + length(longes)-2,:) = missingSpecs;
        missedNum = missedNum+length(longes)-1;
    end
    success_count = success_count +si;
    fail_count = fail_count + fi;
    lati = latNext;
    
end
PercentCoverage = success_count/(success_count+fail_count);

idxes = find(missingSpecsTot(:,1));
actualMissingSpecs = zeros(length(idxes),2);
for m = 1:1:length(idxes)
    actualMissingSpecs(m,:) = [missingSpecsTot(idxes(m),1),missingSpecsTot(idxes(m),2)];
end
    
