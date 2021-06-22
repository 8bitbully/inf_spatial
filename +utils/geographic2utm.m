% utm -> 6 degrees
% dutm -> 3 degrees
function [x, y] = geographic2utm(ellipsoid, B, L, L0, visible)
    if nargin < 5
        visible = false;
    end
    zone = utmzone([B, L]);
    utmstruct = defaultm('utm'); 
    utmstruct.zone = zone; 
    utmstruct.geoid = ellipsoid;
    utmstruct = defaultm(utmstruct);
    utmstruct.origin=[0 L0 0];
    

    [y, x] = projfwd(utmstruct, B, L);
    if visible
        y = y + ((L0+3)/6+30) * 1000000;
    end
end