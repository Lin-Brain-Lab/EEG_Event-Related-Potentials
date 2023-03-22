%% Script to create a customized plot depicting the MMN, its composite ERPs, MinPeak, and PeakMean

function fig = KJ_ERPLABMMNPlot (DATACALC, dataID, ChanName, MMN, eERP, nERP)

% inputs:
%   DATACALC - a structure created with BVDataCalc with all desired datasets
%   dataID - a value designating which dataset in DATACALC is to be plotted
%   ChanName - a string indicating the desired channel to be plotted
%   MMN - the condition ID of the MMN
%   eERP - the condition ID of the emotional ERP
%   nERP - the condition ID of the neutral ERP
% Output:
%   fig - a figure with a customized depiction of the MMN and its composite ERPs, MinPeak, PeakMean,
%   and thier associated values

chanID = find(ismember({DATACALC(1).chanlocs.labels},ChanName)); % defines the temporary variable chanID based on the input ChanName

% initial plotting of datasets
plot (DATACALC(dataID).times(:), DATACALC(dataID).bindata (chanID, :, MMN), 'DisplayName', DATACALC(dataID).bindescr{MMN}) % plots the MMN on a figure
hold on % ensures the following plots appear on the same figure
plot (DATACALC(dataID).times(:), DATACALC(dataID).bindata (chanID, :, eERP), 'DisplayName', DATACALC(dataID).bindescr{eERP}) % plots the deviant ERP
plot (DATACALC(dataID).times(:), DATACALC(dataID).bindata (chanID, :, nERP), 'DisplayName', DATACALC(dataID).bindescr{nERP}) % plots the standard ERP
hold off % removes figure hold

% plot customization
title ([DATACALC(dataID).filename(1:4) ' ' DATACALC(dataID).bindescr{MMN}]); % creates a title for the graph based on data in file
xbound = xlim; % makes the x range into a usable vector
ybound = ylim; % makes the y range into a usable vector
grid % turns a grid on the graph
hold on % ensures that all following transformations happen on top of current graph
plot ([xbound(1), xbound(2)], [0 0], 'color', [0.3 0.3 0.3]) %creates a horizatal line at the y origin
plot ([0 0], [ybound(1), ybound(2)], 'color', [0.3 0.3 0.3]) %creates a verticle line at the x origin
hold off % removes figure hold
legend (replace(DATACALC(dataID).bindescr{MMN}, '_', ' '),...
    replace(DATACALC(dataID).bindescr{eERP}, '_', ' '),...
    replace(DATACALC(dataID).bindescr{nERP}, '_', ' ')) % creates a legend on the graph
ylabel ('Amplitude') %sets the y-axis label
xlabel ('Time (ms)') %sets the x-axis label
xlim ([-100 599]) %limits the x-xis of the specified plot to the specified range

% plot min peak search range as a patch
hold on %ensures the following plot will be put on the current axis
patch ('XData', [DATACALC(dataID).values(chanID, 4, MMN),...
    DATACALC(dataID).values(chanID, 5, MMN),...
    DATACALC(dataID).values(chanID, 5, MMN),...
    DATACALC(dataID).values(chanID, 4, MMN)],... %defines the XData of a patch of colour on the figure...
    'YData', [(ybound(2)), (ybound(2)), (ybound(1)), (ybound(1))], 'DisplayName', 'Search Range') % defines the YData of a patch of colour on the figure
hold off % removes figure hold
alpha (.25) % makes the previously plotted aspect transparent (values 0-1)

% plot the minium peak
hold on %ensures the following plot will be put on the current axis
plot (DATACALC(dataID).values(chanID, 2, MMN), DATACALC(dataID).values(chanID, 1, MMN), 'ro', 'DisplayName', 'Min Peak'); % plot a single point
hold off % removes figure hold

% plot the values included in the peak mean as a patch 
patchxdata = [DATACALC(dataID).values(chanID, 2, MMN) - DATACALC(dataID).values(chanID, 6, MMN),... % timepoint ps of Min - AvgRadius
    (DATACALC(dataID).values(chanID, 2, MMN) - DATACALC(dataID).values(chanID, 6, MMN):... % timepoint ps of Min - AvgRadius
    (DATACALC(dataID).values(chanID, 2, MMN) + DATACALC(dataID).values(chanID, 6, MMN) - 1)),... % timepoint ps of Min + AvgRadius - 1
    DATACALC(dataID).values(chanID, 2, MMN) + DATACALC(dataID).values(chanID, 6, MMN)] + 1; % define a temporary variable patchxdata with x values of a patch
patchydata = [0, DATACALC(dataID).meanrange(chanID, :, MMN), 0]; % define a temporary variable patchydata with y values of a patch
patch (patchxdata, patchydata, 'b', 'DisplayName', 'Averaged Amplitudes'); % plots the patch with the values defined by the variabels patchxdata and patchydata
alpha (.25) % makes the previously plotted aspect transparent (values 0-1)

% reverse axis of plot
ax = gca; %sets the structure of properties of the graph into 'ax'
ax.YDir = 'reverse'; % reverses the direction of the y-axis

