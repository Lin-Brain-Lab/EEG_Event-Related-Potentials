clearvars;
close all;

%% eeglab and data path
addpath('C:\Users\sr810\Documents\MATLAB\eeglab14_1_0b'); % eeglab path
dir_raw = ['D:\mmn_nycu\eeg'];
dir_ana = ['D:\mmn_nycu\analysis'];

for sub_id = 3:19
    
    if sub_id < 10
        subj = ['00' num2str(sub_id)];
    else
        subj = ['0' num2str(sub_id)];
    end
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadbv(dir_raw, ['eMMN-sub' subj '.vhdr'], [], []);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',sub_id,'gui','off');
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    pop_expevents(EEG, [dir_ana '\ev\eMMN-sub' subj '_ev.csv'], 'samples');
    eeglab redraw;
    
end
