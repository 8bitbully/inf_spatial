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

%%% hamit
% B = {
%     [40 52 30], ...
%     [41 0 0], ...
%     [41 0 0], ...
%     [40 52 30]
% };
% 
% L = {
%     [40 0 0], ...
%     [40 0 0], ...
%     [40 7 30], ...
%     [40 7 30]
% };


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

%%%
% inverse = [
%     586575.684 4536440.664
%     587926.123 4535867.262
%     588896.958 4535052.616
%     587774.494 4536342.897];
% 
% forward = [
%     586590.63 4536626.08
%     587941.11 4536052.7
%     588911.98 4535238.03
%     587789.44 4536528.340];

%%%

% 
t = fitgeotrans(inverse, forward, 'NonreflectiveSimilarity');
[xnew, ynew]= transformPointsForward(t, dutm.x, dutm.y);

ed50 = [xnew', ynew'];
itrf = retDutm;

tablo8 = ed50 - itrf

plot(inverse(:, 1), inverse(:, 2), '^r', 'LineWidth', 2)

hold on
plot(ynew, xnew, '+k', 'LineWidth', 1)
plot(dutm.y, dutm.x, '*k', 'LineWidth', 1)
% quiver(dutm.y, dutm.x, ynew, xnew)
axis equal
legend('Kontrol Noktaları', 'Pafta Köşe Noktaları', 'Dönüştürülmüş pafta köşe koordinatları')
