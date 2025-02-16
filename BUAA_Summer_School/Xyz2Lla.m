function [llaDegDegM] = Xyz2Lla(xyzM)
% [llaDegDegM] = Xyz2Lla(xyzM)
%
% Transform Earth-Centered-Earth-Fixed x,y,z, coordinates to lat,lon,alt. 
% Input:    xyzM = [mx3] matrix of ECEF coordinates in meters
% Output:   llaDegDegM = [mx3] matrix = [latDeg,lonDeg,altM]
% latitude, longitude are returned in degrees and altitude in meters
%z

% check inputs
if size(xyzM,2)~=3
    error('Input xyzM must have three columns');
end
% algorithm: Hoffman-Wellenhof, Lichtenegger & Collins "GPS Theory & Practice"
R2D = 180/pi;

%if x and y ecef positions are both zero then lla is undefined
iZero = ( xyzM(:,1)==0 & xyzM(:,2)==0);
xyzM(iZero,:) = NaN; %set to NaN, so lla will also be NaN

xM = xyzM(:,1); yM = xyzM(:,2); zM = xyzM(:,3);
%following algorithm from Hoffman-Wellenhof, et al. "GPS Theory & Practice":
a = GpsConstants.EARTHSEMIMAJOR;
a2 = a^2;
b2 = a2*(1-GpsConstants.EARTHECCEN2);
b = sqrt(b2);
e2 = GpsConstants.EARTHECCEN2;
ep2 = (a2-b2)/b2;
p=sqrt(xM.^2 + yM.^2);

% two sides and hypotenuse of right angle triangle with one angle = theta:
s1 = zM*a;
s2 = p*b;
h = sqrt(s1.^2 + s2.^2);
sin_theta = s1./h;
cos_theta = s2./h;
%theta = atan(s1./s2);

% two sides and hypotenuse of right angle triangle with one angle = lat:
s1 = zM+ep2*b*(sin_theta.^3);
s2 = p-a*e2.*(cos_theta.^3);
h = sqrt(s1.^2 + s2.^2);
tan_lat = s1./s2;
sin_lat = s1./h;
cos_lat = s2./h;
latDeg = atan(tan_lat);
latDeg = latDeg*R2D;

N = a2*((a2*(cos_lat.^2) + b2*(sin_lat.^2)).^(-0.5));
altM = p./cos_lat - N;

% rotate longitude to where it would be for a fixed point in ECI
%lonDeg = atan2(yM,xM) - GpsConstants.WE*deltaTime;
lonDeg = atan2(yM,xM); %since deltaTime = 0 for ECEF
lonDeg = rem(lonDeg,2*pi)*R2D;
if (lonDeg>180)
    lonDeg = lonDeg-360;
end
llaDegDegM = [latDeg, lonDeg,altM];

end %end of function Xyz2Lla
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%