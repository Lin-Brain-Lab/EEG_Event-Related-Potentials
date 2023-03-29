clearvars;
close all;

%% eeglab and data path
addpath('C:\Users\sr810\Documents\MATLAB\eeglab14_1_0b'); % eeglab path
dir_ana = ['D:\mmn_nycu\analysis\'];
ref_ch = [9 20];

for sub_id = [10]
    
    if sub_id < 10
        subj = ['00' num2str(sub_id)];
    else
        subj = ['0' num2str(sub_id)];
    end
    
    eeglab;
    EEG = pop_loadset('filename',['s' subj '_fr.set'],'filepath', dir_ana);
    EEG = eeg_checkset( EEG );
    
    EEG  = pop_basicfilter( EEG, [ 1 29] , 'Boundary', 'boundary', 'Cutoff',  30, ...
        'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    EEG = eeg_checkset( EEG );
    
%     EEG = pop_runica(EEG, 'extended',1,'interupt','on');
%     EEG = pop_runica(EEG, 'icatype', 'jader');

    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',['s' subj '_fric.set'], ...
        'filepath', dir_ana);
    eeglab redraw;
    
end
