function BVDataPlot (DATACALC, chanID, filedir)




close all

% BVDataMMNPlot (DATACALC, dataID, ChanName, MMN, dERP, sERP)
for dataID = 1: length (DATACALC) % for all datasets in the structure DATA
    fig = figure('units','normalized','outerposition',[0 0 1 1]); %maximizes figure & window
    subplot (2, 1, 1);
    BVDataMMNPlot (DATACALC, dataID, chanID, 1, 3, 2);
    subplot (2, 1, 2);
    BVDataMMNPlot (DATACALC, dataID, chanID, 5, 4, 6);
    file = (strcat (filedir, '\', chanID, '_', DATACALC(dataID).partinumb, '_mmn', '.png'));
    saveas (fig, file);
end

