clearvars, clc,

e = referenceEllipsoid('grs80');

B = {
    [40 52 30], ...
    [41 0 0], ...
    [41 0 0], ...
    [40 52 30]
};

L = {
    [39 37 30], ...
    [39 37 30], ...
    [39 45 0], ...
    [39 45 0]
};

B = cellfun(@dms2degrees, B);
L = cellfun(@dms2degrees, L);

for i = 1 : length(B)
    [utm.x(i), utm.y(i)] = utils.geographic2utm(e, B(i), L(i), 39);
    [dutm.x(i), dutm.y(i)] = utils.geographic2dutm(e, B(i), L(i), 39);
    [gauss.x(i), gauss.y(i)] = utils.gaussKruger(e, B(i), L(i), 39);
    [conformConic.x(i), conformConic.y(i)] = utils.dStdLambertConformalConic(e, B(i), L(i));
end

retUtm = [utm.x', utm.y'];
retDutm = [dutm.x', dutm.y'];
retGauss = [gauss.x', gauss.y'];
retConformal = [conformConic.x', conformConic.y'];

tablo5 = retUtm - retDutm
tablo7 = retGauss - retConformal

[inverse, forward, params] = utils.readDNS('docs/1/TRB_ITRF_MEM_1.DNS');

% 
t = fitgeotrans(inverse, forward, 'NonreflectiveSimilarity');
[ynew, xnew]= transformPointsForward(t, dutm.y, dutm.x);

ed50 = [xnew', ynew'];
itrf = retDutm;

tablo8 = ed50 - itrf

plot(inverse(:, 1), inverse(:, 2), '^r', 'LineWidth', 2)

hold on
plot(ynew, xnew, '+k', 'LineWidth', 1)
plot(dutm.y, dutm.x, '*k', 'LineWidth', 1)
% quiver(dutm.y, dutm.x, ynew, xnew, 'AutoScaleFactor', 1)
axis equal
legend('Kontrol Noktaları', 'Pafta Köşe Noktaları', 'Dönüştürülmüş pafta köşe koordinatları')
