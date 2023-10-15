% Generate Grid Points
function longes = GenerateGridPoints(lat1,lat2)
res = 25;
latAVG = (abs(lat1)+abs(lat2))/2;
degPerKm = 1/(111.320*cosd(latAVG));
degPer25km = res*degPerKm;

long_i = -180;
longes = [];
    while long_i < (180-degPer25km)
        longes = [longes,long_i];
        long_i = long_i + degPer25km;
    end
longes = [longes,180];

end