function fig = BVDataMMNPlot (DATACALC, dataID, ChanName, MMN, dERP, sERP)



chanID = find(ismember(DATACALC(dataID).channames,ChanName));


plot (DATACALC(dataID).times(:, chanID, MMN), DATACALC(dataID).data ( :, chanID, MMN), 'DisplayName', DATACALC(dataID).condnames{:,:,MMN}) 
hold on
plot (DATACALC(dataID).times(:, chanID, MMN), DATACALC(dataID).data ( :, chanID, dERP), 'DisplayName', DATACALC(dataID).condnames{:,:,dERP})
plot (DATACALC(dataID).times(:, chanID, MMN), DATACALC(dataID).data ( :, chanID, sERP), 'DisplayName', DATACALC(dataID).condnames{:,:,sERP})
hold off
% plot customization
title ([DATACALC(dataID).partinumb ' ' ChanName]); % creates a title for the graph based on data in file
xbound = xlim; % makes the x range into a usable vector
ybound = ylim; % makes the y range into a usable vector
grid % turns a grid on the graph
hold on % ensures that all following transformations happen on top of current graph
plot ([xbound(1), xbound(2)], [0 0], 'color', [0.3 0.3 0.3]) %creates a horizatal line at the y origin
plot ([0 0], [ybound(1), ybound(2)], 'color', [0.3 0.3 0.3]) %creates a verticle line at the x origin
hold off %allows creation of new graphs
legend ((replace(DATACALC(dataID).condnames{:,:,MMN}, '_', ' ')), (replace(DATACALC(dataID).condnames{:,:,dERP}, '_', ' ')), (replace(DATACALC(dataID).condnames{:,:,sERP}, '_', ' '))) % creates a legend on the graph
ylabel ('Amplitude') %sets the y-axis label
xlabel ('Time (ms)') %sets the x-axis label
xlim ([-100 600]) %limits the x-xis of the specified plot to the specified range
% highlighted areas
hold on %ensures the following plot will be put on the current axis
patch ('XData', [DATACALC(dataID).values(4, chanID, MMN), DATACALC(dataID).values(5, chanID, MMN), DATACALC(dataID).values(5, chanID, MMN), DATACALC(dataID).values(4, chanID, MMN)],...
    'YData', [(ybound(2)), (ybound(2)), (ybound(1)), (ybound(1))], 'DisplayName', 'Search Range')
hold off
alpha (.25) % makes the previously plotted aspect transparent (values 0-1)
hold on %ensures the following plot will be put on the current axis
plot ((DATACALC(dataID).values(2, chanID, MMN) - 2), DATACALC(dataID).values(1, chanID, MMN), 'ro', 'DisplayName', 'Min Peak');
hold off
% patchxdata = [DATACALC(dataID).times(190, chanID, MMN), DATACALC(dataID).times(190:(190 + 50) , chanID, MMN)' , DATACALC(dataID).times( (190+51) , chanID, MMN)] + 165;
patchxdata = [DATACALC(dataID).values(2, chanID, MMN) - 25, (DATACALC(dataID).values(2, chanID, MMN) - 25:DATACALC(dataID).values(2, chanID, MMN) + 25), DATACALC(dataID).values(2, chanID, MMN) + 25] - 1;
patchydata = [0, DATACALC(dataID).meanrange(:, chanID, MMN)', 0];
patch (patchxdata, patchydata, 'b', 'DisplayName', 'Averaged Amplitudes');
alpha (.25)
% reverse axis
ax = gca; %sets the structure of properties of the graph into 'ax'
ax.YDir = 'reverse'; % reverses the direction of the y-axis
