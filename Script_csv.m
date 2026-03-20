%% New script EEG

% Limpiar entorno
close all;
clear all; clc

% Abrir carpeta
cfg = []; 
cfg.dir = ['C:\Users\yangy\Desktop\Listos\Ed Fisica']; 

% Import data
EEG = pop_musemonitor('C:\Users\yangy\Desktop\Muse_EEG\Ed Fisica\Datos\Maximal\maximal_08.csv', 'srate','256','importall','on');
eeglab redraw; 

% Remove Epoch Baseline
EEG = pop_rmbase( EEG, [],[]);
eeglab redraw; 

% Event channel
EEG = pop_chanevent(EEG, 1,'edge','leading','edgelen',0);

% Select channels
EEG = pop_select( EEG, 'channel',{'eeg_1','eeg_2','eeg_3','eeg_4'});
eeglab redraw; 

% Filter Data
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',35,'plotfreqz',1);
eeglab redraw; 


% %% Cut Data
% % Función para cortar datos por ventanas de tiempo
% % Agregar después del filtrado y antes de "Clean Data"
% 
% % Definir ventana de tiempo (formato MM:SS o HH:MM:SS)
% tiempo_inicio = '05:47';
% tiempo_fin = '0:28';
% 
% % Función para convertir tiempo a segundos
% time2sec = @(timestr) sum(cellfun(@str2double, strsplit(timestr, ':')) .* [60, 1]);
% 
% % Convertir tiempos a segundos
% inicio_seg = time2sec(tiempo_inicio);
% fin_seg = time2sec(tiempo_fin);
% 
% % Convertir segundos a frames (samples)
% fs = EEG.srate;  % Tasa de muestreo (debería ser 256 Hz después del resample)
% inicio_frame = round(inicio_seg * fs) + 1;  % +1 porque MATLAB indexa desde 1
% fin_frame = round(fin_seg * fs);
% 
% % Verificar que los índices estén dentro del rango
% if inicio_frame < 1
%     inicio_frame = 1;
% end
% if fin_frame > EEG.pnts
%     fin_frame = EEG.pnts;
%     warning('El tiempo final excede la duración del registro. Se ajustó al final del archivo.');
% end
% 
% % Cortar los datos
% EEG = pop_select(EEG, 'point', [inicio_frame fin_frame]);
% eeglab redraw;


%%
% Clean Data
EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off','ChannelCriterion','off','LineNoiseCriterion','off','Highpass','off','BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] );
eeglab redraw; 

% SAVE DATASET
EEG = pop_saveset( EEG, 'filename','maximal_008.set','filepath','C:\\Users\\yangy\\Desktop\\Listos\\Ed Fisica\\Datos Actualizados\\Maximal V3\\');
EEG = pop_saveset( EEG, 'filename','maximal_008.set','filepath','C:\\Users\\yangy\\Desktop\\Listos\\Ed Fisica\\Datos Actualizados\\All\\');
