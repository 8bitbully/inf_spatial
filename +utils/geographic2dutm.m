% utm -> 6 degrees
% dutm -> 3 degrees
function [x, y] = geographic2dutm(ellipsoid, B, L, L0)
    zone = utmzone([B, L]);
    utmstruct = defaultm('utm'); 
    utmstruct.zone = zone; 
    utmstruct.geoid = ellipsoid;
    utmstruct = defaultm(utmstruct);
    utmstruct.scalefactor = 1;
    utmstruct.origin=[0 L0 0];
    

    [y, x] = projfwd(utmstruct, B, L);
end