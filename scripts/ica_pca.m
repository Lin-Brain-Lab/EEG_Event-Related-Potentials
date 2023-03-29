clearvars;
close all;

%% eeglab and data path
addpath('C:\Users\sr810\Documents\MATLAB\eeglab14_1_0b'); % eeglab path
dir_ana = ['D:\mmn_nycu\analysis\'];
ICnum = [20] ; %29

for sub_id = [10]  %16 17
    
    if sub_id < 10
        subj = ['00' num2str(sub_id)];
    else
        subj = ['0' num2str(sub_id)];
    end
    
    eeglab;
    EEG = pop_loadset('filename',['s' subj '_fr.set'],'filepath',dir_ana);
    EEG = eeg_checkset( EEG );
    
    % Low-pass filter at 30Hz on FP1 and FP2
    EEG  = pop_basicfilter( EEG, [ 1 29] , 'Boundary', 'boundary', 'Cutoff',  30, ...
        'Design', 'butter', 'Filter', 'lowpass', 'Order',  2 );
    EEG = eeg_checkset( EEG );
    
    %% demean
    tmpData = EEG.data;
    meantmpData = mean(tmpData,2);
    EEG.data = tmpData - repmat(meantmpData,[1,EEG.pnts,1]);
    
    %% reshpae data array
    data=EEG.data;
    data=reshape(data,EEG.nbchan,EEG.pnts*EEG.trials);
    
    %% run ICA with initial learning rate at 0.001
    fname = ['s' subj '_fric_pca3'];
    [weights, sphere, compvars] = runica(EEG.data, 'lrate', 0.001, 'pca', ICnum]);
    
    EEG.icachansind= 1:EEG.nbchan;
    EEG.icasphere=sphere;
    EEG.icaweights=weights;
    EEG.icawinv=pinv(EEG.icaweights*EEG.icasphere);
    EEG = pop_saveset( EEG, 'filename',[fname '.set'], 'filepath',dir_ana);
    eeglab redraw;
    
end