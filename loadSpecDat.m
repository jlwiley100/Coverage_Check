function specs = loadSpecDat(output_folder,n_rx)

wgs84 = wgs84Ellipsoid("meter");

specs = [];
RCGs = [];
FFZs = [];

rcgConstraint = 3; % RCG
ffzConstraint = 625; % km^2

%% PARAMETERS
RxName = 'CYG';
TxName = {'GPS', 'Galileo'};
nRx = n_rx;
nTx = length(TxName);
cTc = 3*1e5/(1.023*1e6);

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

        [Xsp, Ysp, Zsp] = geodetic2ecef(wgs84, lats, longs, alts);

        % Meters
        Rts = sqrt((Xtx - Xsp).^2 + (Ytx - Ysp).^2 + (Ztx - Zsp).^2);
        Rsr = sqrt((Xrx - Xsp).^2 + (Yrx - Ysp).^2 + (Zrx - Zsp).^2);

        % Specular FFZ of specular points
        %a = temp(:, 15) ./ 1000;
        %b = temp(:, 16) ./ 1000;

        % Calculations
        % km
        % TODO: Check if Garrison's diffuse FFZ seems correct
        h = Rsr .* sind(90 - angs) ./ 1000;
        a = sqrt((cTc.*h)./(cosd(angs).^3));
        b = sqrt((cTc.*h)./(cosd(angs)));
        
        ffz = pi.*a.*b;

        RCGs = [RCGs; 10.^(gains./10)./(Rts.^2 .* Rsr.^2)];
        FFZs = [FFZs; ffz];

        % Latitudes and longitudes at exactly 0 will not be included. To
        % ensure that they will be, we perturb the latitude and longitude
        % by a small value.
        % LLA of specular points
        lats = temp(:,9) + 0.0001;
        longs = temp(:,10) + 0.0001;
        specs = [specs; lats, longs];  
    end
end

% Multiply all RCG values
RCGs = RCGs(:) * (10^27);

% Filter RCGs less than or equal to 3 and FFZs greater than or equal to 625
% km^2
latsZero = nonzeros( ...
    specs(:,1) .* (RCGs > rcgConstraint) .* (FFZs < ffzConstraint));
lonZero = nonzeros( ...
    specs(:,2) .* (RCGs > rcgConstraint) .* (FFZs < ffzConstraint));

specs = [latsZero lonZero];
specs = sortrows(specs,1);
end


