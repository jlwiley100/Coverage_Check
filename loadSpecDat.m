function specs = loadSpecDat(output_folder,n_rx)

specs = [];
underAngs = [];
%% PARAMETERS
RxName = 'CYG';
TxName = {'Galileo'};
nRx = n_rx;
nTx = length(TxName);
%% GET DIRECTORIES
dir_out = output_folder;
%% READ DATA
opts = delimitedTextImportOptions('Delimiter', ' ', 'VariableTypes', 'double');
for iRx = 1 : nRx
    for iTx = 1 : nTx
        filename = sprintf('%s%d_%s.out', RxName, iRx, TxName{iTx});
        temp = readmatrix(strcat(dir_out, filename), opts);
        
        % LLA of specular points
        lats = temp(:,9);
        longs = temp(:,10);
        specs = [specs;
                lats,longs];
        underAng = temp(:,12) <= 45;
        underAngs = [underAngs; underAng, underAng];
        
        
    end
end

%% PARAMETERS
RxName = 'CYG';
TxName = {'GPS'};
nRx = n_rx;
nTx = length(TxName);
%% GET DIRECTORIES
dir_out = output_folder;
%% READ DATA
opts = delimitedTextImportOptions('Delimiter', ' ', 'VariableTypes', 'double');
for iRx = 1 : nRx
    for iTx = 1 : nTx
        filename = sprintf('%s%d_%s.out', RxName, iRx, TxName{iTx});
        temp = readmatrix(strcat(dir_out, filename), opts);
        
        % LLA of specular points
        lats = temp(:,9);
        longs = temp(:,10);
        underAng = temp(:,12) <= 45;
        underAngs = [underAngs; underAng, underAng];
        specs = [specs; lats, longs];  
    end
end

latsZero = nonzeros(specs(:,1).*underAngs(:, 1));
lonZero = nonzeros(specs(:,2).*underAngs(:, 1));

specs = [latsZero lonZero];
specs = sortrows(specs,1);
end


