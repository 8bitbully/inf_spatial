function [x, y] = dStdLambertConformalConic(ellipsoid, B, L)
    mstruct = defaultm('lambertstd');
    mstruct.mapparallels=[37.5 40.5];
    mstruct.origin=[39 35.5  0];
    mstruct.geoid=ellipsoid;
    mstruct.scalefactor=1;

    [y, x] = projfwd(mstruct, B, L);
end