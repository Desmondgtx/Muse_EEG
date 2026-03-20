%% EEG Muse Anthena S Script
% .edf files processing
% Diego Garrido Cerpa - Viña del Mar 2025

% Clean Workspace
close all;
clear all; clc

% Main Folder
cfg = []; 
cfg.dir = ['C:\Users\yangy\Desktop\Muse_EEG\Ed Fisica']; 

% Import data
EEG = pop_biosig('C:\Users\yangy\Desktop\Muse_EEG\Ed Fisica\Datos\Maximal\maximal_007.edf', 'importannot','off');
eeglab redraw; 

% https://github.com/sccn/eeglab/blob/develop/functions/supportfiles/Standard-10-5-Cap385_witheog.elp
% https://www.tmsi.artinis.com/blog/the-10-20-system-for-eeg
% A pilot study on EEG-based evaluation of visually induced motion sickness. Liu, R., Xu, M., Zhang, Y., Peli, E., & Hwang, A. D. (2020).
% The four electrodes on the Muse headband are:
% 2) AF7 (Left Frontal): Located on the left side, slightly above the eyebrows.
% 3) AF8 (Right Frontal): Located on the right side, slightly above the eyebrows.
% 1) TP9 (Left Temporal): Located on the left side, above the ear, near the temple.
% 4) TP10 (Right Temporal): Located on the right side, above the ear, near the temple.

% Select channels
EEG = pop_select( EEG, 'channel',{'eeg-ch1','eeg-ch2','eeg-ch3','eeg-ch4'});
eeglab redraw; 

% Correct events
EEG = pop_chanevent(EEG, [],'edge','leading','edgelen',0);
eeglab redraw; 

%Resample data
EEG = pop_resample( EEG, 256);
eeglab redraw; 
% https://intl.choosemuse.com/products/muse-s-athena?variant=51832464048493

% Label Channels
standard_labels = {'eeg_1','eeg_2','eeg_3','eeg_4'};  

for i = 1:4
    EEG.chanlocs(i).labels = standard_labels{i};
end
eeglab redraw;

% Re-reference the data
EEG = pop_reref( EEG, []);
eeglab redraw; 

% Filtering
EEG  = pop_basicfilter( EEG,  1:4 , 'Boundary', 'boundary', 'Cutoff', [ 1 35], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2 ); % GUI: 21-Apr-2025 14:49:34
eeglab redraw; 

% %% Cut Data
% % Function to cut data for time window 
% 
% % Define time window (format MM:SS o HH:MM:SS) 
% tiempo_inicio = '04:10';
% tiempo_fin = '04:51';
% 
% % Function to transform time to seconds
% time2sec = @(timestr) sum(cellfun(@str2double, strsplit(timestr, ':')) .* [60, 1]);
% 
% inicio_seg = time2sec(tiempo_inicio);
% fin_seg = time2sec(tiempo_fin);
% 
% % Transform seconds to frames
% fs = EEG.srate;  % Sampling Rate (should be 256Hz)
% inicio_frame = round(inicio_seg * fs) + 1;  % +1 because MATLAB index from 1
% fin_frame = round(fin_seg * fs);
% 
% % Verify time index
% if inicio_frame < 1
%     inicio_frame = 1;
% end
% if fin_frame > EEG.pnts
%     fin_frame = EEG.pnts;
%     warning('El tiempo final excede la duración del registro. Se ajustó al final del archivo.');
% end
% 
% % Cut data
% EEG = pop_select(EEG, 'point', [inicio_frame fin_frame]);
% eeglab redraw;


% Clean Data
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
eeglab redraw; 

% SAVE DATASET
EEG = pop_saveset( EEG, 'filename','maximal_008.set','filepath','C:\\Users\\yangy\\Desktop\\Listos\\Ed Fisica\\Datos Actualizados\\Maximal V3\\');
EEG = pop_saveset( EEG, 'filename','maximal_008.set','filepath','C:\\Users\\yangy\\Desktop\\Listos\\Ed Fisica\\Datos Actualizados\\All\\');
