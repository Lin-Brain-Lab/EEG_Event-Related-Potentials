clearvars;
close all;

%% eeglab and data path
addpath('C:\Users\sr810\Documents\MATLAB\eeglab14_1_0b'); % eeglab path
dir_raw = ['D:\mmn_nycu\eeg'];
dir_ana = ['D:\mmn_nycu\analysis'];

for sub_id = [10]
    
    if sub_id < 10
        subj = ['00' num2str(sub_id)];
    else
        subj = ['0' num2str(sub_id)];
    end
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadbv(dir_raw, ['eMMN-sub' subj '.vhdr'])
    EEG = eeg_checkset( EEG );
    EEG = pop_importevent( EEG, 'append','no','event', ...
        [dir_ana '\ev\eMMN-sub' subj '_ev_r.csv'], ...
        'fields',{'number' 'latency' 'duration' 'type'}, ...
        'skipline',1,'timeunit',NaN,'optimalign','off');
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',['s' subj '.set'],'filepath', dir_ana);

%     EEG = pop_loadset('filename',['s' subj '.set'],'filepath',dir_ana);
%     EEG = eeg_checkset( EEG );
    
    EEG  = pop_basicfilter( EEG,  1:31 , 'Boundary', 'boundary', 'Cutoff', [ 1 70], ...
        'Design', 'butter', 'Filter', 'bandpass', 'Order',  2, 'RemoveDC', 'on' );
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',['s' subj '_f.set'], 'filepath', dir_ana);
    
    EEG = pop_reref( EEG, [9 20] );
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',['s' subj '_fr.set'],'filepath', dir_ana);
    eeglab redraw;

end
