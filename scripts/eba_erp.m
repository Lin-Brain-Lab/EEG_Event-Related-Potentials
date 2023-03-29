clearvars;
close all;

%% eeglab and data path
addpath('C:\Users\sr810\Documents\MATLAB\eeglab14_1_0b'); % eeglab path
dir_ana = 'D:\mmn_nycu\analysis\';
dir_erp = 'D:\mmn_nycu\analysis\erp\';

for sub_id = [10]
    
    if sub_id < 10
        subj = ['00' num2str(sub_id)];
    else
        subj = ['0' num2str(sub_id)];
    end
    
    eeglab;
    EEG = pop_loadset('filename',['s' subj '_fro.set'],'filepath',dir_ana);
    EEG = eeg_checkset( EEG );
    EEG  = pop_editeventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, ...
        'BoundaryString', { 'boundary' }, 'List', 'D:\mmn_nycu\analysis\evlist.txt', ...
        'SendEL2', 'EEG', 'UpdateEEG', 'code', 'Warning', 'on');
    % EEG  = pop_overwritevent( EEG, 'code'  );
    EEG.setname =['s' subj '_froe'];
    EEG = eeg_checkset( EEG );
    
    EEG = pop_saveset(EEG, 'filename',['s' subj '_froe.set'],'filepath', dir_ana);
    EEG = eeg_checkset( EEG );
    % pre-stimulus/baseline correction
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre');
    EEG.setname=['s' subj '_froeb.set'];
    EEG = eeg_checkset( EEG );
    
    EEG = pop_saveset(EEG, 'filename',['s' subj '_froeb.set'],'filepath', dir_ana);
    EEG = eeg_checkset(EEG);
    % artifact detection in epoched data: simple voltage threshold
    EEG  = pop_artextval( EEG , 'Channel',  1:EEG.nbchan, 'Flag',  1, 'Threshold', [ -100 100], 'Twindow', [-200 800]);
    EEG = eeg_checkset(EEG);
    EEG.setname = ['s' subj '_froeba'];
    EEG = eeg_checkset( EEG );
    
    EEG = pop_saveset(EEG, 'filename',['s' subj '_froeba.set'],'filepath', dir_ana);
    EEG = eeg_checkset(EEG);
    
    
    % Compute ERP
    % eba erp
    ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', ['s' subj '_froeba'] , 'filename', ...
        ['s' subj '_froeba.erp'], 'filepath', dir_erp);
    EEG = eeg_checkset(EEG);
    %   ERP bin operation for classical MMN
    ERP = pop_binoperator( ERP, {'BIN31 = BIN1 - BIN2 LABEL MMN(Angry-Neutral)', ... % tgr(100)-tgr(101) 
        'BIN32 = BIN5 - BIN6 LABEL MMN(Sad-Neutral)', ... % tgr(200)-tgr(201) 
        'BIN33 = BIN9 - BIN10 LABEL MMN(Fearful-Neutral)', ... % tgr(300)-tgr(301) 
        'BIN34 = BIN13 - BIN14 LABEL MMN(Neutral-Angry)', ... % tgr(10)-tgr(11) 
        'BIN35 = BIN17 - BIN18 LABEL MMN(Neutral-Sad)', ... % tgr(20)-tgr(21) 
        'BIN36 = BIN21 - BIN22 LABEL MMN(Neutral-Fearful)', ... % tgr(30)-tgr(31) 
        'BIN37 = BIN1 - BIN14 LABEL Angry(Oddball-Freq)', ... % tgr(100)-tgr(11) 
        'BIN38 = BIN5 - BIN18 LABEL Sad(Oddball-Freq)', ... % tgr(200)-tgr(21) 
        'BIN39 = BIN9 - BIN22 LABEL Fearful(Oddball-Freq) '});  % tgr(300)-tgr(31)
    ERP = pop_savemyerp(ERP, 'erpname', ['s' subj '_froeba'] , 'filename', ...
        ['s' subj '_froeba.erp'], 'filepath', dir_erp);
    
% % %     %   ERP bin operation for classical MMN
% % %     ERP = pop_binoperator( ERP, {'BIN37 = BIN1 - BIN15 LABEL Angry(Oddball-Freq)', ... % tgr(100)-tgr(12) 
% % %         'BIN38 = BIN5 - BIN19 LABEL Sad(Oddball-Freq)', ... % tgr(200)-tgr(22) 
% % %         'BIN39 = BIN9 - BIN23 LABEL Fearful(Oddball-Freq)', ... % tgr(300)-tgr(32) 
% % %         'BIN40 = BIN13 - BIN3 LABEL Angry(Oddball-Freq)', ... % tgr(10)-tgr(102) 
% % %         'BIN41 = BIN17 - BIN7 LABEL Sad(Oddball-Freq)', ... % tgr(20)-tgr(202) 
% % %         'BIN42 = BIN21 - BIN11 LABEL Fearful(Oddball-Freq)'}); % tgr(30)-tgr(302) 
% % %     ERP = pop_savemyerp(ERP, 'erpname', ['s' subj '_froeba'] , 'filename', ...
% % %         ['s' subj '_froeba.erp'], 'filepath', erppath);
    
    
    %     ERP = pop_ploterps( ERP, [ 1 2 5 6 9 10],1:29 , 'AutoYlim', 'on', ...
    %         'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 6 5], ...
    %         'ChLabel', 'on', 'FontSizeChan',10, 'FontSizeLeg',12, 'FontSizeTicks',10, ...
    %         'LegPos', 'bottom', 'Linespec', {'k-' , 'r-' , 'b-' , 'g-' , 'c-' , 'm-' }, ...
    %         'LineWidth',1, 'Maximize', 'on', 'Position', [ 103.714 21.1765 106.857 32], ...
    %         'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',0, ...
    %         'xscale', [ -100.0 799.0 -100:100:700 ], 'YDir', 'normal' );
    
end

eeglab redraw;