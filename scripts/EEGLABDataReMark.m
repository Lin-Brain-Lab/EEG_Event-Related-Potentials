%% BVDataReMark
% Updates event codes on EEG Data to enable easier analysis with EEGLAB
%
% Ensures that any deviant stimuli that are not preceded by a boundary are
% not counted as deviant
% Ensures that the standard stimuli preceding a true deviant stimuli is
% coded as 'S 11'
% Adds a 1 to the end of any block code that is at the beginning of a block
%

%% Goal: template script for remarking Data that comes from BrainVision for analysis
% designate dataset to be altered
disp ('Which data set would you like to alter?')
dataList = input ('list in []: '); % asks to determine the dataset they want used
for i = 1: length (dataList)
    dataID = dataList(i);
    %for each event in the log
    for markID = 1: length (ALLEEG(dataID).event) % goes through all events in the dataset
        %Desired Alteration to the data
        if ~isempty (strfind (ALLEEG(dataID).event(markID).type, 'S  2'))... %if current marker is a deviant
                && ~isempty (strfind (ALLEEG(dataID).event(markID -1).type, 'S 1')) %and the preceding marker is not a block code
            ALLEEG(dataID).event(markID - 1).type = 'S 11'; %update preceding Stimulus code
        elseif ~isempty (strfind (ALLEEG(dataID).event(markID).type, 'S  2'))... %if current marker is a deviant
                && isempty (strfind (ALLEEG(dataID).event(markID -1).type, 'S 1')) %and the preceding marker is a block code
            ALLEEG(dataID).event(markID).type = 'S  3'; %update current stimulus code so it is not included as a deviant of interest
        elseif ~isempty (strfind (ALLEEG(dataID).event(markID).type, 'S 11')) %if current marker is 'S 11'
            ALLEEG(dataID).event(markID).type = 'S 12'; %update current stimulus code so it is not included as a standard of interest
        elseif ~isempty (strfind (ALLEEG(dataID).event(markID).type, 'S 2'))... % if current marker is a block code
                && ~isempty (strfind (ALLEEG(dataID).event(markID - 1).type, 'bound')) % and the preceding is a boundary
            ALLEEG(dataID).event(markID).type = [ALLEEG(dataID).event(markID).type '1']; %add a 1 on the end of the block code
        elseif ~isempty (strfind (ALLEEG(dataID).event(markID).type, 'S 3'))... % if current marker is a block code
                && ~isempty (strfind (ALLEEG(dataID).event(markID - 1).type, 'bound')) % and the preceding is a boundary
            ALLEEG(dataID).event(markID).type = [ALLEEG(dataID).event(markID).type '1']; %add a 1 on the end of the block code
        end %end of if/else loop
    end %end of markID loop
end %end of DataList loop

disp ('please refesh the dataset chosen before continuing analysis')