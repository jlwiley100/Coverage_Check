function specs = loadSpecDat(output_folder,n_rx, angleConstraint)

wgs84 = wgs84Ellipsoid("meter");

specs = [];
underAngs = [];
RCGs = [];
FFZs = [];

%% PARAMETERS
RxName = 'CYG';
TxName = {'GPS', 'Galileo'};
nRx = n_rx;
nTx = length(TxName);
cTc = 3*10e8/(1.023);

%% GET DIRECTORIES
dir_out = output_folder;
%% READ DATA
opts = delimitedTextImportOptions('Delimiter', ' ', 'VariableTypes', 'double');
for iRx = 1 : nRx
    for iTx = 1 : nTx
        filename = sprintf('%s%d_%s.out', RxName, iRx, TxName{iTx});
        temp = readmatrix(strcat(dir_out, filename), opts);
        
        % LLA of Rx
        latsRx = temp(:,2);
        longsRx = temp(:,3);
        altRx = temp(:, 4);

        [Xrx, Yrx, Zrx] = geodetic2ecef(wgs84, latsRx, longsRx, altRx);

        % LLA of Tx
        latsTx = temp(:,6);
        longsTx = temp(:,7);
        altTx = temp(:, 8);

        [Xtx, Ytx, Ztx] = geodetic2ecef(wgs84, latsTx, longsTx, altTx);

        % LLA of specular points
        lats = temp(:,9);
        longs = temp(:,10);
        alts = temp(:,11);
        
        gains = temp(:, 13);

        angs = temp(:,17);

        h = sind(90-angs);

        % FFZ of specular points
        a = temp(:, 15) ./ 1000;
        b = temp(:, 16) ./ 1000;
        %a = ((cTc.*alts)./(cosd(angs).^3)).^(0.5);
        %b = ((cTc.*alts)./(cosd(angs))).^(0.5);
        
        ffz = pi.*a.*b;

        [Xsp, Ysp, Zsp] = geodetic2ecef(wgs84, lats, longs, alts);

        Rts = sqrt((Xtx - Xsp).^2 + (Ytx - Ysp).^2 + (Ztx - Zsp).^2);
        Rsr = sqrt((Xrx - Xsp).^2 + (Yrx - Ysp).^2 + (Zrx - Zsp).^2);

        RCGs = [RCGs; 10.^(gains./10)./(Rts.^2 .* Rsr.^2)];
        FFZs = [FFZs; ffz];

        % LLA of specular points
        lats = temp(:,9);
        longs = temp(:,10);
        underAng = temp(:,17) <= angleConstraint;
        underAngs = [underAngs; underAng];
        specs = [specs; lats, longs];  
    end
end

% Multiply all RCG values
RCGs = RCGs(:) * (10^27);

% Filter RCGs less than or equal to 3 and FFZs greater than or equal to 625
% km^2
latsZero = nonzeros(specs(:,1) .* (RCGs > 3) .* (FFZs < 625));
lonZero = nonzeros(specs(:,2) .* (RCGs > 3) .* (FFZs < 625));

specs = [latsZero lonZero];
specs = sortrows(specs,1);
end


