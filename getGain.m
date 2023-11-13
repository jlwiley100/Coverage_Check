function gains = getGain(azimuths,elevations)

%antenna locations
a1 = [30,0];
a2 = [0,30];
a3 = [-30,0];
a4 = [0,-30];
%x and y of specular point on graph
x = azimuths.*cosd(90-elevations);
y = azimuths.*sind(90-elevations);
specPt = [x,y];

%find closest antenna 
d1 = sqrt(sum((specPt-a1).^2,2));
d2 = sqrt(sum((specPt-a2).^2,2));
d3 = sqrt(sum((specPt-a3).^2,2));
d4 = sqrt(sum((specPt-a4).^2,2));

distances = [d1,d2,d3,d4];
M = min(distances,[],2);

%get gains from minimum angles
gains = 12.77803 + 0.03126683*(M) -0.01027357*((M).^2);


end
