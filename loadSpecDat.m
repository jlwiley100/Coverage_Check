function specs = loadSpecDat(output_folder,n_rx, band)

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

if nargin < 3
    band = "L1";
end

if band == "L1"
    cTc = 3*1e5/(1.023*1e6) / 2;
elseif band == "L2"
    cTc = 3*1e5/(1.023*1e6) / 2;
elseif band == "L5"
    cTc = 3*1e5/(1.023*1e6) / 10 / 2;
end


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
        angs = temp(:,17);
        %% TODO
        [azimuths,elevation] = temp(:,??);
        gains = getGain(azimuths,elevation);
        %%
       
       

        [Xsp, Ysp, Zsp] = geodetic2ecef(wgs84, lats, longs, alts);

        % Meters
        Rts = sqrt((Xtx - Xsp).^2 + (Ytx - Ysp).^2 + (Ztx - Zsp).^2);
        Rsr = sqrt((Xrx - Xsp).^2 + (Yrx - Ysp).^2 + (Zrx - Zsp).^2);

        % Specular FFZ of specular points
        % Calculations
        % km
        h = Rsr .* sind(90 - angs) ./ 1000;
        cosangs = cosd(angs);
        a = sqrt(2*(cTc.*h)./(cosangs.^3));
        b = sqrt(2*(cTc.*h)./(cosangs));
        
        ffz = pi.*a.*b;

        % Ideal case
        %RCGs = [RCGs; 10.^(13.8./10)./(Rts.^2 .* Rsr.^2)];
        
        % General case
        RCGs = [RCGs; 10.^(gains./10)./(Rts.^2 .* Rsr.^2)];
        FFZs = [FFZs; ffz];

        % Latitudes and longitudes at exactly 0 will not be included. To
        % ensure that they will be, we perturb those latitude and longitude
        % by a small value, respective of their sign.
        % LLA of specular points
        lats = temp(:,9);
        longs = temp(:,10);

        % TODO: Consider throwing out these
        lats(any(isnan(lats),2),:)=0.003;
        longs(any(isnan(lats),2),:)=0.003;
        lats(any(isnan(longs),2),:)=0.003;
        longs(any(isnan(longs),2),:)=0.003;
       
        lats(lats == 0) = 0.003;
        longs(longs == 0) = 0.003;

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


